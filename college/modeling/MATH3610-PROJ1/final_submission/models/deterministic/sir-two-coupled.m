pkg load odepkg

global beta = 6.0;

global gamma = 4.0;

mixing_original = 2.0;
global mixing= 3.0;

global N_Students = 21000;
global N_Ithacans = 28000;


v_original = 4000;
global v1;
global v2;

function derivs = sir(t, x)
	global beta; global gamma; global N_Students; global N_Ithacans; global v1; global v2; global mixing;
	s1 = x(1); i1 = x(2); r1 = x(3); s2 = x(4); i2 = x(5); r2 = x(6);
	derivs = [ - beta * s1 * i1 / N_Students - mixing * s1 * i2 / N_Ithacans - v1;
		beta * s1 * i1 / N_Students + mixing * s1 * i2 / N_Ithacans - gamma * i1;
		gamma * i1 + v1;
		- beta * s2 * i2 / N_Ithacans - mixing * s2 * i1 / N_Students - v2;
		beta * s2 * i2 / N_Ithacans + mixing * s2 * i1 / N_Students - gamma * i2;
		gamma * i2 + v2];
end

function derivs = sirno1(t, x)
	global beta; global gamma; global N_Students; global N_Ithacans; global v1; global v2; global mixing;
	s1 = x(1); i1 = x(2); r1 = x(3); s2 = x(4); i2 = x(5); r2 = x(6);
	derivs = [ - beta * s1 * i1 / N_Students - mixing * s1 * i2 / N_Ithacans;
		beta * s1 * i1 / N_Students + mixing * s1 * i2 / N_Ithacans - gamma * i1;
		gamma * i1;
		- beta * s2 * i2 / N_Ithacans - mixing * s2 * i1 / N_Students - (v1 + v2);
		beta * s2 * i2 / N_Ithacans + mixing * s2 * i1 / N_Students - gamma * i2;
		gamma * i2 + (v1 + v2)];
end

function derivs = sirno2(t, x)
	global beta; global gamma; global N_Students; global N_Ithacans; global v1; global v2; global mixing;
	s1 = x(1); i1 = x(2); r1 = x(3); s2 = x(4); i2 = x(5); r2 = x(6);
	derivs = [ - beta * s1 * i1 / N_Students - mixing * s1 * i2 / N_Ithacans - (v1+v2);
		beta * s1 * i1 / N_Students + mixing * s1 * i2 / N_Ithacans - gamma * i1;
		gamma * i1 + (v1+v2);
		- beta * s2 * i2 / N_Ithacans - mixing * s2 * i1 / N_Students;
		beta * s2 * i2 / N_Ithacans + mixing * s2 * i1 / N_Students - gamma * i2;
		gamma * i2];
end

function [value, isterminal, parity] = check_for_end(t,x)
	value = x(1) * x(4);
	isterminal = 1;
	parity = -1;
end

function [value, isterminal, parity] = check_for_endno1(t,x)
	value = x(4);
	isterminal = 1;
	parity = -1;
end
function [value, isterminal, parity] = check_for_endno2(t,x)
	value = x(1);
	isterminal = 1;
	parity = -1;
end
options = odeset("RelTol", 1e-2, "AbsTol", 1e-2, "InitialStep", 0.01, "MaxStep", 0.1, "Events", @check_for_end)

warning("off", "all")
V = linspace(0.0, 1.0, 40);
total_cases = zeros(length(V), 3);
total_cases(:,3) = V;
for i = 1:length(V)
	v1 = V(i) * v_original;
	v2 = (1 - V(i)) * v_original;
	[T, X] = ode45(@sir, [0, 12.0], [[0.97, 0.03, 0.00]*N_Students, [0.97, 0.03, 0.00]*N_Ithacans], options)

	if abs(X(end,1)) < 1
		[T2, X2] = ode45(@sirno1, [T(end), 12.0], X(end,:), odeset(options, "Events", @check_for_endno1));
		total_cases(i,1) = X2(end,2) + X2(end,3) - T(end) * v1;
		total_cases(i,2) = X2(end,5) + X2(end,6) - T(end) * v2 - (T2(end) - T(end)) * (v1 + v2);
	else
		[T2, X2] = ode45(@sirno2, [T(end), 12.0], X(end,:), odeset(options, "Events", @check_for_endno2));
		total_cases(i,2) = X2(end,5) + X2(end,6) - T(end) * v2;
		total_cases(i,1) = X2(end,2) + X2(end,3) - T(end) * v1 - (T2(end) - T(end)) * (v1 + v2);
	end
	plot([T; T2], [X; X2]) 
	legend('Cornell Seceptible', 'Cornell Infected', 'Cornell Removed', 'Ithaca Seceptible', 'Ithaca Infected', 'Ithaca Removed')
	print(sprintf("../../figures/coupled/%d.png", i));
end

csvwrite('../../data/interacting-populations.csv', total_cases);
