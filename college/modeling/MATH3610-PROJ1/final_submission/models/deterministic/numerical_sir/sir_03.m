clc; close all; clear;
%===================================%
% SIR model with death and vaccines %
%===================================%

% ----- Model Parameters ----- %
s0 = .95;
i0 = .05;
r0 = .0;
d0 = .0;
N = 60000;

d = .25;
nu = 1/d;
R0 = 1.5;
beta = R0 * nu;
mu = 0.00001709; % * 20;
vaccines = 4000;
gamma = vaccines/N;
% ---------------------------- %

t0 = 0;
tf = 8;
y0 = [s0;i0;r0;d0];
[T,Y] = ode45(@(t,y) sir_update_03(y, beta, nu, mu, gamma), [t0, tf], y0);
 
figure
plot(T,Y(:,1:3))
ylim([0,1])
xlabel('Months since outbreak')
ylabel('Fraction of population')
legend('Susceptible', 'Infected', 'Removed')

epidemic_duration = T(find(Y(:,2) < .01 * max(Y(:,2)),1)) % months
total_deaths = Y(end,4) * N                               % people
total_suffering = trapz(T,Y(:,2)) * N                     % person-months
