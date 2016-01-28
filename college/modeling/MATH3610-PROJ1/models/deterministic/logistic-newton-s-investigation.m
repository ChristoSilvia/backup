global r = 1.0;
global K = 1.0;
global r_v = 0.2;
global s_0 = 0.05;

function s = s(t)
	global r; global K; global r_v; global s_0;
	s = exp(r.*t.*(K - r_v .* t ./ 2)) ./ (1 ./ s_0 + sqrt(pi .* r ./ (2 * r_v)) .* exp( 0.5 * r ./ r_v .* K.^2) .* ( erf( sqrt(0.5 * r ./ r_v) .* (r_v .* t - K)) - erf(- sqrt(0.5 * r ./ r_v) .* K)));
end

function [s, jac] = minimizee(t)
	global r; global K; global r_v; global s_0;
	s = exp(r.*t.*(K - r_v .* t ./ 2)) ./ (1 ./ s_0 + sqrt(pi .* r ./ (2 * r_v)) .* exp( 0.5 * r ./ r_v .* K.^2) .* ( erf( sqrt(0.5 * r ./ r_v) .* (r_v .* t - K)) - erf(- sqrt(0.5 * r ./ r_v) .* K))) - (K - r_v * t);
	jac = r * s * (K - s - r_v * t) + r_v;
end

D = linspace(0.01, 0.1, 500);
R = linspace(0.2, 2.0, 10);
points = zeros(length(D),1+length(R));
points(:,1) = D;
t_1_previous = 8.0;
for i = 1:length(D)
	for j = 1:length(R)
		r = R(j);
		r_v = D(i) * r_v;
		t_1 = fsolve(@minimizee, t_1_previous);
		t_1_previous = t_1;
		s_1 = s(t_1);
		r_v = 0.2;
		points(i,j+1) = s_1;
	end
end

csvwrite("data/s-values.csv", points)
hold on
for j = 1:length(R)
	plot(points(:,1), points(:,1+j));
end
hold off
pause

