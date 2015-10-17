
function reception = Q(x,y)
	reception = 20 - 5*x.^2 - 5*y.^2;
end

function total_arclength = arclength(path, domain)
	total_arclength = 0;
	for i = 2:length(path)
		dx = domain(i) - domain(i-1);
		total_arclength += sqrt(1 + (path(i) - path(i-1)).^2./(dx.^2)) .* dx;
	end
end

function result = average_reception(path, domain)
	summand = 0;
	for i = 2:length(path)
		summand += Q(domain(i), path(i))*(domain(i)-domain(i-1));
	end
    result = summand/arclength(path, domain);
end

function path = rescale_to_given_arclength(domain, path, l, tol)
    if (domain(end) - domain(1)) > l
		error('Not possible')
	end

	linear_path = path(1) + (domain - domain(1))*((path(end) - path(1))/(domain(end) - domain(1)));
	deviation = path - linear_path;

	this_step = 0.1;

	old_arclength = arclength(linear_path + deviation, domain);
	while abs(old_arclength - l) > tol
		while abs(old_arclength - l) > this_step
			if old_arclength < l
				deviation(2:end-1) *= (1.0 + this_step);
			elseif old_arclength > l
				deviation(2:end-1) *= (1.0 - this_step);
			end
			old_arclength = arclength(linear_path + deviation, domain);
		end
		this_step /= 2;
	end
	path = linear_path + deviation;
end



L = 3;
n_iterations = 1000;
n_interval = 3;
n_final = 5;
scaling = 0.01;
index = 1:n_interval:n_final;
results = zeros(n_iterations * length(1:n_interval:n_final),1);
for j = 1:length(index)
	if index(j) == 1
		domain = [ -2, -1 + 1/sqrt(8), 0 ];
		guess = [ 0, -1+1/sqrt(8), -2 ];
	else
		old_domain = domain;
		domain = linspace(-2, 0, index(j)+2);
		guess = interp1(old_domain, guess, domain, 'cubic');
	end

	printf('Beginning to anneal for n=%d\n', index(j))
	temperature = 0.0*ones(n_iterations,1);
	results((j-1)*n_iterations + 1) = average_reception(guess, domain);
	noise = randn(1, index(j));
	for i = 2:n_iterations
		new_guess = guess;
		new_guess(2:end-1) += scaling * noise;
		new_guess = rescale_to_given_arclength(domain, new_guess, L, 0.001);
		new_reception = average_reception(new_guess, domain);
		if new_reception > results((j-1)*n_iterations +i-1)
			% leave noise unchanged
			printf('Success: %f > %f\n', new_reception, results((j-1)*n_iterations +i-1));
			guess = new_guess;
			results((j-1)*n_iterations + i) = new_reception;
		else
			noise = randn(1, index(j));
			if rand() > (1 - temperature(i))
				printf('Failure: %f < %f. Accepting.\n', new_reception, results((j-1)*n_iterations +i-1));
				guess = new_guess;
				results((j-1)*n_iterations + i) = new_reception;
			else
				printf('Failure: %f < %f. Rejecting.\n', new_reception, results((j-1)*n_iterations +i-1));
				results((j-1)*n_iterations + i) = results((j-1)*n_iterations +i-1);
			end
		end
	end
end

plot(results)
pause

clf()
plot(domain, guess)
pause

