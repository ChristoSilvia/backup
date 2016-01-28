pkg load odepkg

solinit.x = linspace(0,1, 4);
solinit.y = [ 1 1 1 1; 1 1 1 1];
solinit

function dydx = f(x, y)
	y
	dydx = [ y(2); -abs(y(1))]
end

function c = bv(fa, fb)
	[ fa(1) - 1.0; fb(1) + 0.5]
end

bvp4c(@f, @bv, solinit)


