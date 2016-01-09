pkg load odepkg;

global l1 = 1.0; %meters
global l2 = 0.5; %meters
global d1 = 0.5; %meters
global d2 = 0.25; %meters
global m1 = 0.2; %kg
global m2 = 0.1; %kg
global I1 = 1.0/12.0 * m1 * l1.^2; % kg m^2
global I2 = 1.0/12.0 * m2 * l2.^2; % kg m^2
global g = 9.8 % m / sec^2
global n = 2;

% initial_conditions:
theta_1_initial = 2*pi*rand();
theta_2_initial = 2*pi*rand();
p_1_initial = 0.0;
p_2_initial = 0.01;

x_initial = [theta_1_initial, theta_2_initial, p_1_initial, p_2_initial];

m = 300;

T = linspace(0,4,m);
X = lsode(@(x) integrate_hamiltonian(x), x_initial, T);

for i = 1:m
	A = [zeros(1,2); l1*cos(X(i,1)) l1*sin(X(i,1)); l1*cos(X(i,1)) + l2*cos(X(i,1) + X(i,2)) l1*sin(X(i,1)) + l2*sin(X(i,1) + X(i,2)) ]; 
	plot(A(:,1),A(:,2))
	axis(1.1*[-(l1+l2) l1 + l2 -(l1+l2) l1+l2])
	print(sprintf('arm-movie-1/arm-%04d.png',i))
end

pause
