
min_r = 0.05;
max_r = 3.0;
min_f = 0.05;
max_f = 2.0;
n_r = 20;
n_f = 20;
n_iterations = 100;
t_max = 5.0;
R = linspace(min_r, max_r, n_r);
F = linspace(max_f, min_f, n_f);
T = linspace(0, t_max, n_iterations);

results = zeros(n_iterations, 2*(n_f+1)*(n_r+1));

current_index = 1.0;
for i = 1:length(R)
	for j = 1:length(F)
		results(:, [current_index, current_index+1]) =  lsode(@(x) [ (1.0 - 1.0 .* x(2)) .* x(1) - 1.0 .* x(1).^2 ./ 1.0, (1.0 .* x(1) - 1.0).* x(2) ], [R(i), F(j)], T);
		current_index += 2;
	end
end

hold on
current_index = 1.0;
for i = 1:length(R)
	for j = 1:length(F)
		plot(results(:,current_index+1), results(:,current_index));
		current_index += 2;
	end
end
hold off
title("A=1, B=1, C=1, D=1, K=1.0")
print("plots/phase-potrait-degenerate.png")
pause
