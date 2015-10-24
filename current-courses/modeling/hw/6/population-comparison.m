r = 0.7;        %rate of reproduction (newborn per current animal per year)

n = 1;          %how often do we "compound"
p = r/n;        %rate of reproduction per "time step"

T = 20;         %number of years
deltaT = 1/n;   %time step

tt = deltaT*(0:(n*T));      %all time instances when we change the population size

figure; hold on;

initial_population = 100;
n_trials = 100;
time_elapsed = zeros(1, n_trials);

tic
for j=1:n_trials;
   m = initial_population;    %init population size
   mm = [m];
   for t=tt(2:end);
		m=m+sum(rand(1,m) < p);  %updated/current population size
		mm = [mm, m];  %population change history
   end

   plot(tt, mm, 'color', 'blue');
end
randomtime = toc/n_trials;

tic
for j=1:n_trials;
   m = initial_population;    %init population size
   mm = [m];
   for t=tt(2:end);
		std_div = sqrt(m*p*(1 - p));
		thing_mean = m * p;
		sampled = normrnd(thing_mean, std_div);
		m=m+sampled;  %updated/current population size
		mm = [mm, m];  %population change history
   end

   plot(tt, mm, 'color', 'green');
end
normrndtime = toc/n_trials;

title(sprintf('Gaussian Approximation to Bernoulli Trials, Initial Population = %d',initial_population))
plot(tt, mm(1)*(1+p).^(0:(n*T)), 'r', 'LineWidth', 3);
print(sprintf('gauss-approx-init-%d.png',initial_population))

%	mean(time_elapsed)
%	plot(time_elapsed)
%	hist(time_elapsed)
%	csvwrite('runtimes-bernoulli.csv',time_elapsed)
printf('Random Time: %f\n', randomtime);
printf('Normrnd Time: %f\n', normrndtime);
pause
