A = load("us_pop_data.csv");

function total_error = get_squared_error(r, K, data)
	n = length(data(:,1));
	total_error = 0.0;

	for i = 1:n
		t_0 = data(1,i);
		N_0 = data(2,i);
		for j = (i+1):n
			t_f = data(1,j);
			N_f = data(2,j);
			total_error += 0.5 *  ( K .* ( N_0 .* exp( r .* (t_f - t_0))) ./ ( (K - N_0) + N_0 .* exp( r .* (tf - t_0))) - N_f).^2;
		end
	end
end

function total_error_gradient = get_error_gradient(r, K, data)
	n = length(data(:,1));
	total_error_gradient = [ 0.0; 0.0];

	for i = 1:n
		t_0 = data(i, 1);
		N_0 = data(i, 2);
		for j = (i+1):n
			t_f = data(j, 1);
			N_f = data(j, 2);
			total_error_gradient  += ( K .* ( N_0 .* exp( r .* (t_f - t_0))) ./ ( (K - N_0) + N_0 .* exp( r .* (t_f - t_0))) - N_f) .* [ N_0 .* exp(r .* (t_f - t_0)) .*(K - N_0 + N_0 .*exp(r .* (t_f - t_0))) - N_0 .* exp(r .* (t_f - t_0)); (K - N_0) .* (t_f - t_0) .* N_0 .* exp(r .* (t_f - t_0)) ] ./ (K - N_0 + N_0 .*exp(r .* (t_f - t_0))).^2;
		end
	end
end

function result = normalize(vec)
	result = vec ./ sum(vec);
end

r_initial = 0.4;
K_initial = 600;

params = [r_initial; K_initial]
for i = 1:1000
	params -= [0.01; 1.0] .*  normalize(get_error_gradient(params(1), params(2), A));
	params
end
get_squared_error(r,K,A)
