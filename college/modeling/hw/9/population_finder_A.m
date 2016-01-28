function attractiveness = N(x)
	attractiveness = exp(-(x - 0.5).^2);
end

m_full = 10;
A_full = linspace(0,exp(-0.25),m_full);

m_partial = 5;
A_partial = linspace(exp(-0.25), 1.0, m_partial);

A = [ A_full A_partial];
size(A)
pops = zeros(m_full+m_partial,1);

for i = 1:m_full
	pops(i) = quad(@(x) sqrt(N(x)./A_full(i) - 1), 0, 1);
end

for i = 1:m_partial
	pops(m_full+i) = quad(@(x) sqrt(N(x)./A_partial(i) - 1.0), 0.5 - sqrt(-log(A_partial(i))), 0.5 + sqrt(-log(A_partial(i))));
end


subplot(211)
hold on
plot(A, pops)
xlabel('Attractiveness')
ylabel('total population')
hold off

%%%
subplot(212)
hold on
xlabel('x')
ylabel('q(x)')

% full
x = linspace(0,1);
for i = 1:m_full
	plot(x, sqrt(N(x)./A_full(i) - 1))
end

% partial
for i = 1:m_partial
	x = linspace(0.5 - sqrt(-log(A_partial(i))), 0.5 + sqrt(-log(A_partial(i))));
	plot(x, sqrt(N(x)./A_partial(i)-1.0))
end
hold off

%	for P = 0.05:0.05:1
%		[p_closest, i_closest] = min(abs(pops - P));
%		q_initial_for_P = fsolve(@(q) population(q) - P, qinitials(i_closest));
%		printf('q: %f \t p: %f\n', q_initial_for_P, P)
%	end


pause
