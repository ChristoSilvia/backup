function between = percentage_between_ages(r, min_age, max_age)
	A = setup_a(r);
	
	[v,d] = eig(A);
	[eigval, j] = max(abs(diag(d)));
	ages = v(:,j);
	between = sum(ages(min_age:max_age))/sum(ages);
end

r_between = fzero(@(r) percentage_between_ages(r, 15, 64) - 0.6, 0.5);
r_between_above = fzero(@(r) percentage_between_ages(r, 15, 64) - 0.6, 0.71);

r_values = 0.0:0.01:1.0;
percentage_working_age_values = zeros(1,length(0.0:0.01:1.0));
for i = 1:length(r_values)
	percentage_working_age(i) = percentage_between_ages(r_values(i),15,64);
end

hold on
plot(r_values, percentage_working_age, ';Percentage Working Age;');
plot(r_values, 0.6*ones(1,length(r_values)), sprintf(';60 percent cutoff. Minimum r is %f;', r_between));
scatter([r_between, r_between_above], [percentage_between_ages(r_between, 15, 64), percentage_between_ages(r_between_above,15,64)]);

xlabel('r');
ylabel('Working-Age Percentage of the Population');
title('Natality Coefficient Effectos on Working-Age Percentage of the Population');
hold off
print('working-age.pdf')

printf('R must be between %f and %f', r_between, r_between_above)

pause



