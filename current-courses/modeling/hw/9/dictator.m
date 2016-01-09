function n = N(x)
	n = exp(-(x - 0.5).^2);
end

k = 200;
x = linspace(0,1,k);
hold on
Cs = 0.5:0.01:exp(-0.25);
m = length(Cs);
for i =1:m
	q = N(x) ./ Cs(i) + sqrt( (N(x)./Cs(i)).^2 - 1.0);
	plot(x, q)
	P = quad(@(x) (N(x)./Cs(i)) .* (1 + sqrt(1.0 - (Cs(i) ./ N(x)).^2 ) ), 0, 1)
	happiness = (Cs(i)/2.0)/P
end
pause
