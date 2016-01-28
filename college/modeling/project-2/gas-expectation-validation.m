% model parameters
w = 2.0; % width of container
h = 3.0; % height of container
r = 0.1; % radius of drone vision

eps = 1e-13;
huge = 1e15;

% simulation parameters
n_steps = 10000; % number of events
n_drones = 10; % number of drones at a time

% set up randomly distributed velocites all with
%	unit magnitude
v = zeros(n_drones,2);
for i = 1:n_drones
	theta = 2*pi*rand();
	v(i,:) = [cos(theta), sin(theta)];
end

% place drones randomly within the domain,
%	but a distance of no less than r away from
%	the walls
x = [r, r] + [w-r,h-r] .* rand(n_drones,2);

% array to save the drones in
X = zeros(n_drones, n_steps, 2);

target = [1.0 1.0];

t = 0;
time_intervals = zeros(1,n_steps); % save event times
within_circle = norm(min(target - x)) < r
circle_status = zeros(1,n_steps);

for i = 1:n_steps
    % for each drone, find the time until it collides with each wall
	tls = (r - x(:,1))./v(:,1);
	trs = (w - r - x(:,1))./v(:,1);
	tbs = (r - x(:,2))./v(:,2);
	tts = (h - r - x(:,2))./v(:,2);

	% for each wall, find the minimum positive time until a collision
	%	with it, and which drone this time corresponds to.
	[tl, il] = min(tls + (huge*(tls < eps)));
	[tr, ir] = min(trs + (huge*(trs < eps)));
	[tb, ib] = min(tbs + (huge*(tbs < eps)));
	[tt, it] = min(tts + (huge*(tts < eps)));
    [t_so_far, which_wall] = min([tl, tr, tb, tt]);

	a = v(:,1).^2 + v(:,2).^2;
	neg_b = 2*(v(:,1).*(target(1) - x(:,1)) + v(:,2).*(target(2) - x(:,2)));
	c = (x(:,1) - target(1)).^2 + (x(:,2) - target(2)).^2 - r.^2;
	discriminant = neg_b.^2 - 4*a.*c;
	for j = 1:n_drones
		if discriminant(j) > 0
			t_enter = (neg_b(j) - sqrt(discriminant(j)))./(2*a(j));
			t_exit = (neg_b(j) + sqrt(discriminant(j)))./(2*a(j));
			if t_enter > eps && t_enter < t_so_far
				t_so_far = t_enter;
				within_circle = 1;
				which_wall = 0;
			elseif t_exit > eps && t_exit < t_so_far
				t_so_far = t_exit;
				within_circle = 0;
				which_wall = 0;
			end
		end
	end
	circle_status(i) = within_circle;

	% find the minimum overall time until a wall collision,
	%	and which wall will be collided with

	% move the drones forwards and advance time
	x += v * t_so_far;
	t += t_so_far;
	printf('%d',which_wall)

	% if the drone collides with the left or right wall, invert the x velocity.
	% if it collides with the top or bottom wall, invert the y velocity
	if which_wall == 1
		v(il, 1) = -v(il,1);
	end
	if which_wall == 2
		v(ir, 1) = -v(ir,1);
	end
	if which_wall == 3
		v(ib, 2) = -v(ib,2);
	end
	if which_wall == 4
		v(it, 2) = -v(it,2);
	end

	for j = 1:n_drones
		if (x(j,1) < r) || (x(j,1) > w-r) || (x(j,2) < r) || (x(j,2) > h-r)
			theta = rand();
			v(j,:) = [ cos(2*pi*theta) sin(2*pi*theta)];
			x(j,:) = [r,r] + [w-r,h-r].*rand(1,2);
		end
	end

	% record the timestamp and the drone positions at this time	
	time_intervals(i) = t_so_far;
	X(:,i,:) = x;
end

printf('\n')

max_time_until = 20.0
time_untils = (0.0:0.1:max_time_until);
n = length(time_untils);

t_max = sum(time_intervals);
time_in_observation = zeros(1,n);
last_i = -1;
for j = 1:n
	for i = 1:(n_steps-1)
		if circle_status(i) == 1
			time_since_last_collision = sum(time_intervals(last_i+2:i));
			time_in_observation(j) += time_intervals(i+1) + min([time_untils(j), time_since_last_collision]);
			last_i = i;
		end
	end
end

A = (w - 2*r)*(h-2*r);
predicted_probability_in_observation_of_one = (pi*r.^2 + 2*r*1.0*time_untils) / A;

printf('\n');
mean(time_intervals)

%	subplot(2,2,1)
%	plot(cumsum(time_intervals),circle_status)
%	
%	subplot(2,2,2)
%	hold on
%	for i = 1:n_drones
%		plot(X(i,:,1),X(i,:,2))
%	end
%	hold off
%	
%	subplot(2,2,3)
%	for i = 1:n_drones
%		scatter(X(i,:,1),X(i,:,2))
%	end
%	
%	subplot(2,2,4)
%	
hold on
plot(time_untils,ones(length(time_untils)))
plot(time_untils, 1.0 - (1.0 - predicted_probability_in_observation_of_one).^n_drones,'color','green');
plot(time_untils, time_in_observation/t_max,'color','blue');
legend('theory','experiment','location','southeast');
axis([0,max_time_until,-0.1,1.1])
hold off

print('theory-vs-experiment.png')
pause
