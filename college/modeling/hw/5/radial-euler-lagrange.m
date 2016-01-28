pkg load odepkg;

function total_arclength = arclength(path, domain)
	total_arclength = 0;
	for i = 2:length(path)
		dx = domain(i) - domain(i-1);
		total_arclength += sqrt(1 + (path(i) - path(i-1)).^2./(dx.^2)) .* dx;
	end
end

function g = G(r)
	if r < 2
		g = 20 - 5*r.^2;
	else
		g = 0;
	end
end

function g = dGdr(r)
	if r < 2
		g = - 10 * r;
	else
		g = 0;
	end
end

function derivs = f(t, x)
	global l;
	derivs = [ x(2), x(1) + 2 * x(2).^2./x(1) + dGdr(x(1))./(G(x(1)) + l).*(x(2).^2 + x(1).^2) ];
end

global opts = odeset('RelTol', 1e-6,
              'AbsTol', 1e-6,
			  'MaxStep', 1e-2,
			  'InitialStep',1e-2,
			  'NormControl', 'on')

global l;
l = -30;

global r_desired = 2.0;
function e = shooting_error(r_0)
	global r_desired;
	global opts;
	[T, X] = ode45(@f, [1.25 * pi, 1.5*pi], [r_0, 0.0], opts);
	e = X(end, 1) - r_desired;
end

center_start = fzero(@shooting_error, 0.5);
[T, X] = ode45(@f, [1.25*pi, 1.5*pi], [center_start, 0.0], opts);
center_start
arclength = sum(sqrt((T(2:end) - T(1:end-1)).^2.*T(2:end).*2 +  (X(2:end,1) - X(1:end-1,1)).^2))

%	hold on
%	for r_0 = [linspace(0, center_start, 15), linspace(center_start, 2, 10)]
%		plot(r_0 .* cos(0:0.01:2*pi), r_0.*sin(0:0.01:2*pi))
%		[T, X] = ode45(@f, [1.25*pi, 1.5*pi], [r_0, 0.0], opts);
%		plot(X(:,1).*cos(T), X(:,1).*sin(T))
%	end
%	hold off 
%	pause

global desired_length = 4.0;

function a = arclength_error(lambda)
	global l;
	global desired_length;
	lambda
	global opts;
	n_intervals = 1000;
	l = lambda;
	printf('Beginning to find the center-start\n');
	center_start = fzero(@shooting_error, 1.0);
	printf('Center-Start: %f\n', center_start);
	%[T, X] = ode45(@f, linspace(1.25*pi, 1.5*pi, n_intervals), [center_start, 0.0], opts);
	[T, X] = ode45(@f, [1.25*pi, 1.5*pi], [center_start, 0.0], opts);
	arclength = sum(sqrt((T(2:end) - T(1:end-1)).^2.*T(2:end).*2 +  (X(2:end,1) - X(1:end-1,1)).^2))
	a = arclength - desired_length
end

last_center_start = 1.0;
lambda_values = [(-400:10:-80),(-75:5:-35),(-30.0:2:-26.0),-25.0,-24.0,(-23.8:0.2:-21.6),(-21.5:0.05:-20.90),(-20.87:0.02:-20.4),(-20.39:0.01:-20.06),(-20.055:0.005:-20.035),(-20.033:0.002:-20.025)];
center_start_values = zeros(1,length(lambda_values))
hold on
for i = 1:length(lambda_values)
	l = lambda_values(i)
	if i > 3
		initial_point = spline(lambda_values(1:i-1), center_start_values(1:i-1), [lambda_values(i)])
	else
		initial_point = last_center_start
	end
	center_start = fsolve(@shooting_error, initial_point)
	center_start_values(i) = center_start;
	last_center_start = center_start;
	[T, X] = ode45(@f, [1.25 * pi, 1.5*pi], [center_start, 0.0], opts);
	plot(X(:,1) .* cos(T), X(:,1) .* sin(T));
	plot(X(:,1) .* cos((1.25*pi - T)+1.25*pi), X(:,1) .* sin((1.25*pi - T)+1.25*pi));
end
title('Time-Optimal Cell Phone Curves')
xlabel('x')
ylabel('y')
axis([-2.5, 0.5, -2.5, 0.5])
hold off
print('time-optimal-curves.png')
pause

plot(lambda_values, center_start_values)
title('Parameter Values for Given Miminum Radii')
xlabel('lambda (must be <20)')
ylabel('radius of closest approach to center')
print('parameter-values.png')
pause

%	clf()
%	hold on
%	plot(lambda_values, - log(sqrt(2) - center_start_values)./log(20 - lambda_values))
%	plot(lambda_values, log(sqrt(2)./(sqrt(2)-center_start_values))./(20 - lambda_values))
%	hold off
%	pause

% lambda = fzero(@arclength_error, [-400, -24.0])

