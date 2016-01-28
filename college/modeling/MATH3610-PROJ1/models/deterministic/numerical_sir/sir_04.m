clc; close all; clear;
%=======================================================%
% SIR model with death, vaccines, and 4 sub-populations %
%=======================================================%

% ----- Model Parameters ----- %
N = 60000;
demographics = [.0248; .6058; 0; .0628];
demographics(3) = 1 - sum(demographics);
s0 = .95 * demographics;
i0 = .05 * demographics;
r0 = .0 * demographics;
d0 = .0 * demographics;

d = .25;
gamma = 1/d;
R0 = [3.00, 0.10, 0.10, 0.10; ...
      0.10, 3.00, 1.00, 0.10; ...
      2.00, 2.00, 1.50, 1.00; ...
      0.10, 0.10, 0.50, 1.00];
beta = R0 * gamma;
mu = 0.00001709 * [4.5;2.1;1.0;1.7]; % * 20;
vaccines = 4000;
vaccine_distribution = [.25;.25;.25;0];
vaccine_distribution(4) = 1 - sum(vaccine_distribution);
nu = vaccines*vaccine_distribution/N;
% ---------------------------- %

t0 = 0;
tf = 8;
y0 = [s0;i0;r0;d0];
[T,Y] = ode45(@(t,y) sir_update_04(y, beta, gamma, mu, nu), [t0, tf], y0);

titles = {'Babies & Toddlers', 'School-Aged', 'Adults', 'Elderly'};
for i = 1:4
    figure
    switch i
        case 1
            set(gcf,'units','normalized','outerposition',[0 0.5 .5 .5])
        case 2
            set(gcf,'units','normalized','outerposition',[0.5 0.5 .5 .5])
        case 3
            set(gcf,'units','normalized','outerposition',[0 0 .5 .5])
        otherwise
            set(gcf,'units','normalized','outerposition',[0.5 0 .5 .5])
    end
    plot(T,Y(:,i:4:8+i) / demographics(i))
    ylim([0,1])
    title(titles(i))
    xlabel('Months since outbreak')
    ylabel('Fraction of population')
    legend('Susceptible', 'Infected', 'Removed')
end

total_deaths = zeros(1,4);
epidemic_duration = zeros(1,4);
total_suffering = zeros(1,4);

for i = 1:4
    total_deaths(i) = Y(end,12+i) * N;                                % persons
    epidemic_duration(i) = T(find(Y(:,4+i) < .01 * max(Y(:,4+i)),1)); % months
    total_suffering(i) = trapz(T,Y(:,4+i)) * N;                       % person-months
end

total_deaths
epidemic_duration
total_suffering
