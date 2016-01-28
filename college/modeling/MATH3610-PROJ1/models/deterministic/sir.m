pkg load odepkg

% contact rate
global beta;

% removal rate
global gamma;

% total population
global N = 60000;

% vaccination rate
global v = 4000;

function derivs = sir(t, x)
	global beta; global gamma; global N; global v;
	s = x(1); i = x(2); r = x(3);
	derivs = [ - beta * s * i / N - v; beta * s * i / N - gamma * i; gamma * i + v ];
end

function [ value, isterminal, parity] = check_for_end(t, x)
	value = x(1);
	isterminal = 1;
	parity = -1;
end

options = odeset("RelTol", 1e-2, 
                 "AbsTol", 1e-2, 
				 "InitialStep", 0.01, 
				 "MaxStep", 0.1,
				 "Events", @check_for_end)

warning("off", "all")
Beta = linspace(0.6, 2.0, 20);
Gamma = linspace(0.1, 0.45, 20);
results = zeros(length(Beta), length(Gamma));
for i = 1:length(Beta)
	for j = 1:length(Gamma)
		beta = Beta(i);
		gamma = Gamma(j);
		beta
		gamma
		[T, Y] = ode45(@sir, [0, 15.0], [ 0.98; 0.02; 0.0 ]*N, options);
		results(i,j) = Y(end, 2) + Y(end, 3) - v*T(end);
		Y(end, 2) + Y(end, 3) - v*T(end)
	end
end

[bmesh, gmesh] = meshgrid(Beta, Gamma);
mesh(bmesh, gmesh, results)
csvwrite('../../data/sir-parameter.csv', results);
results
%plot(T, Y)
%legend('Seceptible','Infected','Removed')
pause
