pkg load odepkg

% contact rate
global beta = 6.0;

% removal rate
global gamma = 4.0;

% total population
N_Students = 21000;
N_Ithacans = 28000;
global N;

% vaccination rate
v_original = 4000;
global v;

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
V = linspace(0.0,1.0,40);
total_cases = zeros(length(V),3);
total_cases(:,3) = V;
for i = 1:length(V)
	clf()
	v = V(i) * v_original;
	N = N_Students;
	[TY, Y] = ode45(@sir, [0, 12.0], [ 0.97; 0.03; 0.0 ]*N_Students, options);

	v = (1 - V(i)) * v_original;
	N = N_Ithacans;
	[TZ, Z] = ode45(@sir, [0, 12.0], [ 0.97; 0.03; 0.0]*N_Ithacans, options);
	
	% time ordered products lol
	if TZ(end) > TY(end)
		v = v_original;
		N = N_Ithacans;
		[m, closest_z_index] = min(abs(TY(end) - TZ));
		[TZ2, Z2] = ode45(@sir, [TY(end), 12.0], Z(closest_z_index,:), options);
		total_cases(i, 1) = Y(end,2) + Y(end,3) - V(i) * v_original *TY(end);
		total_cases(i, 2) = Z2(end,2) + Z2(end,3) - (1-V(i)) * v_original * TZ(end) - v_original * ( TZ2(end) - TZ2(1));
		hold on
		plot(TY, Y(:,1));
		title(sprintf('Ithaca Cases: %f, Cornell Cases: %f', total_cases(i,2), total_cases(i,1)))
		plot([TZ(1:closest_z_index); TZ2], [Z(1:closest_z_index,1); Z2(:,1)]);
		legend('Students', 'Ithacans')
		hold off
	else
		v = v_original;
		N = N_Students;
		[m, closest_y_index] = min(abs(TZ(end) - TY));
		[TY2, Y2] = ode45(@sir, [TZ(end), 12.0], Y(closest_y_index, :), options);
		total_cases(i, 1) = Y2(end,2) + Y2(end,3) - V(i) * v_original * TY(end) - v_original * (TY2(end) - TY2(1));
		total_cases(i, 2) = Z(end,2) + Z(end,3) - (1 - V(i)) * v_original *TZ(end);
		hold on
		plot([TY(1:closest_y_index); TY2], [Y(1:closest_y_index,1); Y2(:,1)]);
		title(sprintf('Ithaca Cases: %f, Cornell Cases: %f', total_cases(i,2), total_cases(i,1)))
		plot(TZ, Z(:,1));
		legend('Students', 'Ithacans');
		hold off
	end
%	print(sprintf('../../figures/top/%d.png',i));
end


%csvwrite('../../data/decoupled-sir-with-redistribution.csv', total_cases);
%plot(V, total_cases);
%axis([0,1,0,60000]);
%pause
%plot(T,[Y (Y(:,2) + Y(:,3) - v * T)])
%legend('Susceptible', 'Infected', 'Removed', 'Cumulative Sick')
