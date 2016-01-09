m_max = 10000
p = 0.5
random_times = zeros(1, m_max);
normrnd_times = zeros(1, m_max);
analytic_times = zeros(1, m_max);

dummy1 = 0.0;
dummy2 = 0.0;
dummy3 = 0.0;

for m = 1:m_max
	tic
	dummy1 = sum(rand(1,m) < p);
	random_times(m) = toc;

	tic
	dummy2 = normrnd(m*p,sqrt(m*p*(1 - p)));
	normrnd_times(m) = toc;

	tic
	dummy3 = sqrt(m*p*(1 - p))*erfi(2*rand()-1) + m*p;
	analytic_times(m) = toc;

end

hold on
plot(random_times, 'color', 'red')
plot(normrnd_times, 'color', 'green')
plot(analytic_times, 'color', 'blue')
legend('seperate trials','normrnd', 'erfi')
hold off
pause

