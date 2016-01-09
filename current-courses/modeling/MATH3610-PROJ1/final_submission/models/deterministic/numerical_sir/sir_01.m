clc; close all; clear;
pkg load odepkg
%===========%
% SIR model %
%===========%

% ----- Model Parameters ----- %
s0 = .99;
i0 = .01;
r0 = .0;

d = .25;
nu = 1/d;
R0 = 1.5;
beta = R0 * nu;
% ---------------------------- %

t0 = 0;
tf = 8;
y0 = [s0;i0;r0];
[T,Y] = ode45(@(t,y) sir_update_01(y, beta, nu), [t0, tf], y0);

figure
plot(T,Y)
xlabel('Months since outbreak')
ylabel('Fraction of population')
legend('Susceptible', 'Infected', 'Removed')
pause
