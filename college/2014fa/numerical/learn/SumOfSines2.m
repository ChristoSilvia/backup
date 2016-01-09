% Script File: SumOfSines2
% Plots the functions
%     f(x) = 2sin(x) + 3sin(2x) + 7sin(3x) + 5sin(4x)
%     g(x) = 8sin(x) + 2sin(2x) + 6sin(3x) + 9sin(4x)
% Accross the interval [-10,10]

close all
n = 200;
x = linspace(-10,10,n)';
A = [sin(x) sin(2*x) sin(3*x) sin(4*x)];
y = A * [2 8; 3 2; 7 6; 5 9];
plot(x,y)
