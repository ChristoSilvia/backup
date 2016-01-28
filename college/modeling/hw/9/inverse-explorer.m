function x = N_inverse(a)
	x = 0.5 + sqrt(-log(a));
end

a = linspace(0,1)
plot(a, N_inverse(a))
pause
