function z = f(s)
	z = (s - sin(s))./(1 - cos(s));
end

for y = 0.1:0.1:1.0
	s = fzero(@(s) f(s) - 1.0/y, 3.5);
	C = (2 * y)/(1 - cos(s));
	printf('s: %f\t C:%f\n', s, C)
end
