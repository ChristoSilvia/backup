w = 2.0;
h = 3.0;
r = 0.1;

eps = 1e-5;
huge = 1e15;

n_steps = 1000;
n_drones = 50;

v = zeros(n_drones,2);
for i = 1:n_drones
	vvec = 2*rand(1,2)-1;
	v(i,:) = vvec / norm(vvec);
end

x = zeros(n_drones,2);
for i = 1:n_drones
	xi = 1.1*[r,r] + ([w,h] - 2.2*r).* rand(1,2);
	while min((x(1:i,1) - xi(1)).^2 + (x(1:i,2) - xi(2)).^2) < 4*r.^2
		xi = 1.1*[r,r] + ([w,h] - 2.2*r).* rand(1,2);
	end
	x(i,:) = xi
end

X = zeros(n_drones, n_steps, 2);
times = zeros(1, n_steps);
in_radius = zeros(1, n_steps);

target = [1.0 1.0];

if min((x(:,1) - target(1)).^2 + (x(:,2) - target(2)).^2) < r.^2
	within_radius = 1;
else
	within_radius = 0;
end

t = 0;
for i = 1:n_steps
    tls = (r - x(:,1))./v(:,1);
	trs = (w - r - x(:,1))./v(:,1);
	tbs = (r - x(:,2))./v(:,2);
	tts = (h - r - x(:,2))./v(:,2);
	[tl, il] = min(tls + (huge*(tls < eps)));
	[tr, ir] = min(trs + (huge*(trs < eps)));
	[tb, ib] = min(tbs + (huge*(tbs < eps)));
	[tt, it] = min(tts + (huge*(tts < eps)));

    [t_so_far, which_wall] = min([tl, tr, tb, tt]);

	t_drone_collision = Inf;
	collision = 0;
	drone_1 = 0;
	drone_2 = 0;
	for n = 1:n_drones
		for m = n:n_drones
			a = (v(n,1) - v(m,1)).^2 + (v(n,2) - v(m,2)).^2;
			b = 2 * ( (x(n,1) - x(m,1))*(v(n,1) - v(m,1)) + (x(n,2) - x(m,2))*(v(n,2) - v(m,2)));
			c = (x(n,1) - x(m,1)).^2 + (x(n,2) - x(m,2)).^2 - 4*r.^2;
			if (b.^2 - 4*a*c) > 0
				negative_root = (- b - sqrt(b.^2 - 4 *a * c))/(2*a);
			%	positive_root = (- b + sqrt(b.^2 - 4 *a * c))/(2*a);
				if negative_root > 0 && negative_root < t_so_far
					t_so_far = negative_root;
					drone_1 = n;
					drone_2 = m;
					collision = 1;
				end
			end
		end
	end
	
	for n = 1:n_drones
		a = v(n,1).^2 + v(n,2).^2;
		b = 2 * ( (x(n,1) - target(1))*(v(n,1)) + (x(n,2) - target(2))*v(n,2));
		c = (x(n,1) - target(1)).^2 + (x(n,2) - target(2)).^2 - r.^2;
		if (b.^2 - 4*a*c) > 0
			negative_root = (- b - sqrt(b.^2 - 4 *a * c))/(2*a);
			positive_root = (- b + sqrt(b.^2 - 4 *a * c))/(2*a);
			if negative_root > eps && negative_root < t_so_far
				collision = 2;	
				t_so_far = negative_root;
				within_radius = 1;
			elseif positive_root > eps && positive_root < t_so_far
				collision = 2;
				t_so_far = positive_root;
				within_radius = 0;
			end	
		end
	end

	x += v * t_so_far;
	t += t_so_far;
	X(:,i,:) = x;
	times(i) = t;
	in_radius(i) = within_radius;
   
	printf('%d\t%d\n',collision,within_radius);
	if collision == 0
		if which_wall == 1
			v(il, 1) *= -1;
		end
		if which_wall == 2
			v(ir, 1) *= -1;
		end
		if which_wall == 3
			v(ib, 2) *= -1;
		end
		if which_wall == 4
			v(it, 2) *= -1;
		end
	elseif (collision == 1)
		one_to_two = x(drone_2,:) - x(drone_1,:);
		V_cm = (v(drone_1,:) + v(drone_2,:))/2;
		mag_v_cm = norm(v(drone_2,:) - v(drone_1,:))/2.0;
		v_f_cm_2 = one_to_two / norm(one_to_two) * mag_v_cm;
		v_f_cm_1 = - one_to_two / norm(one_to_two) * mag_v_cm;
		v(drone_1,:) = V_cm + v_f_cm_1;
		v(drone_2,:) = V_cm + v_f_cm_2;
	end	
	
	angle = linspace(0,2*pi);
	clf
	hold on
	for j = 1:n_drones
		plot(x(j,1) + r*cos(angle), x(j,2) + r*sin(angle))
	end
	scatter([target(1)],[target(2)])
	hold off 
	print(sprintf('movie/balls-%04d.png',i))
end

%hold on
%for i = 1:n_drones
%	plot(X(i,:,1),X(i,:,2))
%end
%hold off
% plot(times, in_radius);
pause
