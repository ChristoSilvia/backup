pkg load odepkg

function n = N(x)
	n = exp(-(x-0.5).^2);
end

function n = Nprime(x)
	n = -(x-0.5).*exp(-(x-0.5).^2);
end

function c = C(q)
	c = 1.0./(1.0 + q.^2);
end

function c = Cprime(q)
	c = -2.0*q./(1 + q.^2).^2;
end

function dydx = f(x, y)
	dydx = [ y(2, :); (-Nprime(x)./N(x)).*(C(y(2,:))./(Cprime(y(2,:))))]
end

function bvs = boundary_function(ya, yb)
	global P;
	bvs = [ ya(1); yb(1) - P];
end

global P = 1.0;
xinit = [0 0.5 1];
yinit = [0.3 0.2 0.1; 0.3 0.2 0.1];

solinit.x = xinit;
solinit.y = yinit;
solinit.solver = "bvp4c";

sol = bvp4c(@f, @boundary_function, solinit)
