% model parameters
w = 3.0; % width of container
h = 2.0; % height of container
r = 0.1; % radius of drone vision

eps = 1e-12;
huge = 1e15;

% simulation parameters
n_steps = 1000; % number of events
n_drones = 50; % number of drones at a time

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
x = 2*[r, r] + [w-4*r,h-4*r] .* rand(n_drones,2);

% array to save the drones in
X = zeros(n_drones, n_steps, 2);

t = 0;
time_intervals = zeros(1,n_steps); % save event times

function [min_val, index] = min_positive(x)
	n = length(x);
	min_val = Inf;
	index = 0;
	for i = 1:n
		if (x(i) > 0) && (x(i) < min_val)
			index = i;
			min_val = x(i);
		end
	end
end

for i = 1:n_steps
    % for each drone, find the time until it collides with each wall
	tls = (r - x(:,1))./v(:,1);
	trs = (w - r - x(:,1))./v(:,1);
	tbs = (r - x(:,2))./v(:,2);
	tts = (h - r - x(:,2))./v(:,2);

	% for each wall, find the minimum positive time until a collision
	%	with it, and which drone this time corresponds to.
	[tl, il] = min_positive(tls);
	[tr, ir] = min_positive(trs);
	[tb, ib] = min_positive(tbs);
	[tt, it] = min_positive(tts);

	% find the minimum overall time until a wall collision,
	%	and which wall will be collided with
    [t_so_far, which_wall] = min([tl, tr, tb, tt]);

	% move the drones forwards and advance time
	x += v * t_so_far;
	t += t_so_far;
	printf('.')

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

	% record the timestamp and the drone positions at this time	
	time_intervals(i) = t_so_far;
	X(:,i,:) = x;
end

[X(:,end,1) X(:,end,2)]
csvwrite('ideal-gas-positions.csv',[X(:,end,1) X(:,end,2)])
