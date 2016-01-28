pkg load odepkg;

function total_arclength = arclength(path, domain)
	total_arclength = 0;
	for i = 2:length(path)
		dx = domain(i) - domain(i-1);
		total_arclength += sqrt(1 + (path(i) - path(i-1)).^2./(dx.^2)) .* dx;
	end
end

function g = G(x,y)
	if x.^2 + y.^2 < 4
		g = 20 + 5*x.^2 + 5*y.^2;
	else
		g = 0;
	end
end

function dgdx = dGdx(x,y)
	if x.^2 + y.^2 < 4
		dgdx = - 10 * x;
	else
		dgdx = 0;
	end
end

function dgdy = dGdy(x,y)
	if x.^2 + y.^2 < 4
		dgdy = - 10 * y;
	else
		dgdy = 0;
	end
end

global l;

function derivs = get_derivs(t, x)
	global l;
	derivs = [ x(2), (1 + x(2).^2).*( dGdy(t, x(1)) - dGdx(t, x(1)) .* x(2))./(G(t, x(1)) + l)];
end

global opts = odeset('RelTol', 1e-6,
              'AbsTol', 1e-6,
			  'MaxStep', 1e-2,
			  'InitialStep',1e-2,
			  'NormControl', 'on')

global last_correct_slope = -2.5;

function x_final = get_error(initial_slope)
	global opts;
	[T, X] = ode45(@get_derivs, [-2, 0], [ 0, initial_slope ], opts);
	x_final = X(end, 1) + 2
end

function path_length = get_length(l_value)
	global opts;
	global last_correct_slope;
	global l;
	l_value
	l = l_value
	l
	initial_slope = fsolve(@get_error, -last_correct_slope);
	last_correct_slope = initial_slope;
	[T, X] = ode45(@get_derivs, [-2, 0], [ 0, initial_slope ], opts);
	path_length = arclength(X(:,1), T) - 2.8
end

l = 30;
[T, X] = ode45(@get_derivs, [-2, -1.5], [ 0, -4.0 ], opts);
plot(T, X(:,1))
pause
