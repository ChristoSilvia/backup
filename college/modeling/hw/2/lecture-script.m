

r = 0.7;        %rate of reproduction (newborn per current animal per year)

n = 1;          %how often do we "compound"
p = r/n;        %rate of reproduction per "time step"

T = 35;         %number of years
deltaT = 1/n;   %time step

tt = deltaT*(0:(n*T));      %all time instances when we change the population size

%figure; hold on;

max_final = 0;
min_final = Inf;

for j=1:40
    m = 10;    %init population size
    mm = [m];
    for t=tt(2:end);
        m=m+sum(rand(1,m) < p);  %updated/current population size
        mm = [mm, m];  %population change history
    end

 %   plot(tt, mm);
    
    if (max_final < mm(end))
        max_final = mm(end);
    else
        if (min_final > mm(end))
            min_final = mm(end);
        end
    end
    
        
end

% plot(tt, mm(1)*(1+p).^(0:(n*T)), 'r', 'LineWidth', 3);

spread = (max_final - min_final)
relative_spread = (max_final - min_final) / ( mm(1)*(1+p)^(n*T) )
