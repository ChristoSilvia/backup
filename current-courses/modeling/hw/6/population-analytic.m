r = 0.7;        %rate of reproduction (newborn per current animal per year)

n = 1;          %how often do we "compound"
p = r/n;        %rate of reproduction per "time step"

T = 20;         %number of years
deltaT = 1/n;   %time step

tt = deltaT*(0:(n*T));      %all time instances when we change the population size

figure; hold on;

max_final = 0;
min_final = Inf;

n_trials = 100;
time_elapsed = zeros(1, n_trials);

for j=1:n_trials;
   tic
   m = 10;    %init population size
   mm = [m];
   for t=tt(2:end);
		std_div = sqrt(m*p*(1 - p));
		thing_mean = m * p;
		sampled = std_div * sqrt(2) * erfi(2 * rand() + 1) + thing_mean;
		m=m+sampled;  %updated/current population size
		mm = [mm, m];  %population change history
   end

   plot(tt, mm);
   
   if (max_final < mm(end))
       max_final = mm(end);
   else
       if (min_final > mm(end))
           min_final = mm(end);
       end
   end
   
   time_elapsed(j) = toc;
end


plot(tt, mm(1)*(1+p).^(0:(n*T)), 'r', 'LineWidth', 3);

spread = (max_final - min_final)
relative_spread = (max_final - min_final) / ( mm(1)*(1+p)^(n*T) )
%	mean(time_elapsed)
%	plot(time_elapsed)
%	hist(time_elapsed)
csvwrite('runtimes-erfi.csv',time_elapsed)
pause
