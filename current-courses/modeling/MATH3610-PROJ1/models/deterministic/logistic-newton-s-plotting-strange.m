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

D = linspace(0.06, 1.0, 10);
T = linspace(0, 20, 1000);
hold on
for i = 1:length(D)
	r_v = 0.2*D(i);
	plot(T, s(T));
end
hold off
pause

