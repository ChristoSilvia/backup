% P = load("us_pop_data.csv");
P = load("paramecium_pop_data.csv");

tol = 1e-14;
results = zeros((length(P(:,1)) * (length(P(:,1)) - 1) * (length(P(:,1) - 2)))/6, 2);

function k = K(r, t_0, t_1, N_0, N_1)
	k = N_1 .* (exp( r .* (t_1 - t_0) ) - 1.0 ) ./ (exp(r * (t_1 - t_0)) - N_1 ./ N_0);
end

function result = f(r, t_0, t_1, t_2, N_0, N_1, N_2)
%	result = (N_1 - 1) .* exp(r .* (t_0 - t_2)) + (1 - N_0) .* exp(r .* (t_1 - t_2)) + N_0 .* (1 - 1 ./ N_2) .* exp(r .* (t_1 - t_0)) - (N_1 - N_0) ./ N_2;
	result = exp(r .* (t_1 - t_0)) + (N_2 ./ N_0) .* (1 - N_1 ./ N_0) .* exp(r .* (t_0 - t_2));
end


function result = df(r, t_0, t_1, t_2, N_0, N_1, N_2)
	% result = (N_1 - 1) .* (t_0 - t_2) .* exp(r .* (t_0 - t_2)) + (1 - N_0) .* (t_1 - t_2) .* exp(r .* (t_1 - t_2)) + N_0 .* (1 - 1 ./ N_2) .* (t_1 - t_0) .* exp(r .* (t_1 - t_0)) - (N_1 - N_0) ./ N_2;
	result = (t_1 - t_0) .* exp(r .* (t_1 - t_0)) + (t_0 - t_2) .* (N_2 ./ N_0) .* (1 - N_1 ./ N_0) .* exp(r .* (t_0 - t_2));
end

results_index = 1;
for i = 1:length(P(:,1))
	for j = (i+1):length(P(:,1))
		for k = (j+1):length(P(:,1))
			for r = linspace(0.1,4.5,20)
				n_runs = 0;
				while (abs(f(r, P(i,1), P(k,1), P(j,1), P(i,2), P(k,2), P(j,2))) > tol) && (n_runs < 100)
					r -= f(r, P(i,1), P(k,1), P(j,1), P(i,2), P(k,2), P(j,2)) ./ df(r, P(i,1), P(k,1), P(j,1), P(i,2), P(k,2), P(j,2));
					n_runs += 1;
				end
				if n_runs < 100
					break
				end
			end
			n_runs
			[ r, K(r, P(i,1), P(k,1), P(i, 2), P(k, 2))]
			if (n_runs < 100) && (0 < r) && (r < Inf)
				results(results_index,:) = [ r, K(r, P(i,1), P(k,1), P(i, 2), P(k, 2))];
				results_index += 1;
			end
		end
	end
end

A = results(1:(results_index-1),:)

scatter(A(:,1), A(:,2))
mean(A(abs(A(:,2)) < 500 ,2))
mean(A(:,1))
pause



%	hold on
%	for i = 1:length(P(:,1))
%		for j = i:length(P(:,1))
%			exponential = exp(r_domain * (P(j,1) - P(i,1)));
%			plot( r_domain, (1 - exponential) ./ ((P(j,2)/P(i,2)) - exponential));
%		end
%	end
%	for i = 1:(length(P(:,1))-1)
%		j = i + 1;
%		exponential = exp(r_domain * (P(j,1) - P(i,1)));
%		plot( r_domain, (1 - exponential) ./ ((P(j,2)/P(i,2)) - exponential));
%	end
%	hold off
%	axis([0, 0.5, 0, 400]);
%	pause
