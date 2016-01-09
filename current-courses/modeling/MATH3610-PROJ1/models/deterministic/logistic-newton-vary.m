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

R = linspace(0.2, 3.0, 20);
D = linspace(0.01, 0.99, 100);
points = zeros(length(D), 1+2*length(R));
points(:,1) = D;
t_1_previous = 8.0;
t_2_previous = 8.0;
for j = 1:length(R)
	for i = 1:length(D)
	
		r = R(j);

		r_v = D(i) * r_v
		t_1 = fsolve(@minimizee, t_1_previous);
		t_1_previous = t_1;
		s_1 = s(t_1)
		r_v = 0.2;

		r = 1.0;

		r_v = (1.0 - D(i)) * r_v
		t_2 = fsolve(@minimizee, t_2_previous);
		t_2_previous = t_2;
		s_2 = s(t_2)
		r_v = 0.2;
		
		points(i,(2*j:2*j+1)) = [s_1, s_2];
	end
end

csvwrite("data/different-r-pareto-front.csv", points)
points
hold on
for i = 1:length(R)
	scatter(points(:,2*i), points(:,2*i+1))
end
hold off
pause

