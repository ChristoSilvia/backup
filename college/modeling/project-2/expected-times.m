global A = 6.0;
global r = 0.1;
global v = 1.0;

function prob = cdf_in_time(t)
	global A; global r; global v;
	vt = v.*t;
	asquared = r.^2 + vt.^2;
	a = sqrt(asquared);
	prob = (pi*r.^2 + 2*r.*vt + asquared.*(asin(r./a) - acos(vt./a)))./A;
end


T = linspace(0,1);
plot(T,cdf_in_time(T))
pause



