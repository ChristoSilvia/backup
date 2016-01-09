function attractiveness = N(x)
	attractiveness = exp(-(x - 0.5).^2);
end

function x = N_inverse(a)
	x = 0.5 + sqrt(-log(a));
end

m = 100;
qinitials = linspace(0.01, 10.0, m);
pops = zeros(m,1);

for i = 1:m
	pops(i) = quad(@(x) sqrt((N(x)/N(0))*(1 + qinitials(i).^2) - 1), 0, 1)
end

function P = population(qinitial)
	P = quad(@(x) sqrt((N(x)/N(0)).*(1 + qinitial.^2) - 1), 0, 1);
end

hold on
plot(qinitials, pops)
scatter([0],[min(pops)])
xlabel('population density at x=0')
ylabel('total population')
hold off

printf('minimum initial population: %f', min(pops))

%	for P = 0.05:0.05:1
%		[p_closest, i_closest] = min(abs(pops - P));
%		q_initial_for_P = fsolve(@(q) population(q) - P, qinitials(i_closest));
%		printf('q: %f \t p: %f\n', q_initial_for_P, P)
%	end


pause
