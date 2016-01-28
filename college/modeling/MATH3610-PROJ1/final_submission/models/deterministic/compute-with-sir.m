pkg load odepkg

% contact rate
global beta = 1.0;

% removal rate
global gamma = 0.2;

% total population
global N = 60000;

% vaccination rate
global v = 4000;

function derivs = sir(t, x)
	global beta; global gamma; global N; global v;
	s = x(1); i = x(2); r = x(3);
	if s >= 0.0
		derivs = [ - beta * s * i / N - v; beta * s * i / N - gamma * i; gamma * i + v ];
	else
		derivs = [ 0; - gamma * I; gamma * I ];
	end
end

function [ value, isterminal, parity] = check_for_end(t, x)
	value = x(1);
	isterminal = 1;
	parity = -1;
end

global options = odeset("RelTol", 1e-10, 
                 "AbsTol", 1e-8, 
				 "InitialStep", 0.01, 
				 "MaxStep", 0.3,
				 "Events", @check_for_end);

function total_infected = model_with_sir(beta_input, gamma_input)
	global options;
	global beta = beta_input;
	global gamma = gamma_input;
	global N;
	global v;
	[T, Y] = ode45(@sir, [0, 15], [ 0.98; 0.02; 0.0 ]*N, options);
	
	total_infected = Y(end, 2) + Y(end, 3) - v*T(end);
end

%	tx = ty = linspace(0.1, 2.0, 10)';
%	[betas, gammas] = meshgrid(tx, ty);
%	mesh( betas, gammas, model_with_sir(betas, gammas));

model_with_sir(1.0, 0.3);
pause
