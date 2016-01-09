function attractiveness = N(x)
	attractiveness = exp(-(x - 0.5).^2);
end

m_full = 100;
A_full = linspace(0,exp(-0.25),m_full);

m_partial = 6;
A_partial = linspace(exp(-0.25), 1.0, m_partial);

A = [ A_full A_partial];

function total = P(A)
	if A > exp(-0.25)
		total = quad(@(x) sqrt(N(x)./A - 1.0), 0.5 - sqrt(-log(A)), 0.5 + sqrt(-log(A)));
	else
		total = quad(@(x) sqrt(N(x)./A - 1), 0, 1);
	end
end
		

P_of_A = zeros(m_full + m_partial, 1);
for i = 1:(m_full + m_partial)
	P_of_A(i) = P(A(i));
end

csvwrite('total_population_individual.csv', [A' P_of_A])

%	hold on
%	plot(A, P_of_A)
%	scatter([e.^(-0.25)],[P_of_A(m_full)])
%	xlabel('Attractiveness')
%	ylabel('total population')
%	hold off
%	pause
