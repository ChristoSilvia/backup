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
		
P_desired = 0.05:0.05:1.0;
m = length(P_desired);
A_achieving = zeros(1,m);
for i = 1:m
	A_achieving(i) = fsolve(@(A) P(A) - P_desired(i), 0.8);
	printf('Population %f \t Enjoyment %f\n', P_desired(i), A_achieving(i))
end

n = 50;

Domains = zeros(n, m)
Ranges = zeros(n, m)
C = zeros(n, m*2);


hold on
for i = 1:m
	if A_achieving(i) > exp(-0.25)
		x = linspace(0.5 - sqrt(-log(A_achieving(i))), 0.5 + sqrt(-log(A_achieving(i))), n);
	else
		x = linspace(0,1,n);
	end
	q = sqrt(N(x)./A_achieving(i) - 1.0)
	Domains(:, i) = x;
	Ranges(:, i) = q;
	plot(x, q);
end
hold off

csvwrite('individual-choice-qs.csv', [Domains Ranges])

pause
