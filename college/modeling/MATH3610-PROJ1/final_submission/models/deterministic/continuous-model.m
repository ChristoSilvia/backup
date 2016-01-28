global r = 0.5;
global K = 60000;
global vaccination_rate = 4000; % 4000 vaccines per month

function result = logistic(x, t)
	global r; global K; global vaccination_rate;
	N = x(1);
	if N + vaccination_rate * t <= K
		result = [ r.*N.*(1 - N./(K - vaccination_rate * t))];
	else
		result = [ 0.0 ];
	end
end

T = linspace(0.0, 14.0, 1000);

hold on
for i = 0.0:1000:60000
	X = lsode(@logistic, [i], T);
	plot(T, X);
end
hold off
pause

