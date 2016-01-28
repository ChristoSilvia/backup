pkg load odepkg;

function n = N(x)
	n = exp(-(x-0.5).^2);
end

function n = Nprime(x)
	n = -2*(x - 0.5) * exp(-(x-0.5).^2);
end

function dqdx = f(x, q)
	dqdx = (Nprime(x) ./ N(x)) .* ((1 - q(1).^4)./(6*q(1) - 2*q(1).^3));
end

function [ value, isterminal, direction] = event(x,q)
	value = q;
	isterminal = 1;
	direction = -1;
end

%	hold on
%	title('Beachgoer Density Maximizing Average Happiness')
%	n = 30;
%	qmiddle = linspace(0.01, 1,n);
%	for i = 1:n
%		[T, X] = ode45(@f, [0.5 1], qmiddle(i), odeset('Events', @event, 'AbsTol', 1e-8));
%		plot(T, X)
%		plot(1-T, X)
%		integral = sum((T(2:end) - T(1:end-1)).*X(2:end));
%		printf('middle: %f \t integral: %f\n', qmiddle(i), integral)
%	end
%	xlabel('position on beach')
%	ylabel('beachgoer density')

function pop = get_population(qmiddle)
	[T, X] = ode45(@f, [0.5 1], qmiddle, odeset('Events', @event, 'AbsTol', 1e-8));
	pop = 2*sum((T(2:end) - T(1:end-1)).*X(2:end));
end	

p_requireds = 0.05:0.05:1.0
v = length(p_requireds)

function s = C(q)
	s = 1.0 ./ (1.0 + q.^2);
end

function S = satisfaction(T,X)
	left_hand = (T(2:end) - T(1:end-1))
	pop = 2*sum(left_hand.*X(2:end));
	S = (2*sum(left_hand.*(N(T(2:end)).*C(X(2:end))).*X(2:end)))./pop;
end

hold on

SV = zeros(v,2)

for i = 1:v
	q_middle_required = fsolve(@(q) get_population(q) - p_requireds(i), 0.4)
	[T, X] = ode45(@f, [0.5 1], q_middle_required, odeset('Events', @event, 'AbsTol', 1e-8));
	plot(T,X)
	plot(1-T,X)
	SV(i,1) = p_requireds(i);
	SV(i,2) = satisfaction(T,X);
end
title('Beachgoer Density Maximizing Average Happiness')
xlabel('position on beach')
ylabel('beachgoer density')

csvwrite('satisfactions.csv', SV);

%	hold on
%	qinitial = linspace(0.001,1);
%	n = length(qinitial);
%	for i = 1:n
%		[T, X] = ode45(@f, [0 1], qinitial(i));
%		plot(T, X)
%	end
%	xinitial = linspace(0.02, 0.4);
%	m = length(xinitial)
%	for i = 1:m
%		[T, X] = ode45(@f, [xinitial(i) 1-xinitial(i)], [1e-14])
%		plot(T, X)
%	end
%	hold off
% print('dictator-distributions.png')
pause
