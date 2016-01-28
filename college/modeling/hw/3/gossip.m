function p_dist = p_dist(K,N)
	leading_coefficient = factorial(K/2) / nchoosek(K,N);
	offset = (rem(N,2) != 0);
	
	% a_max is N if a is even, N-1 if a is odd.

	a_max = min(N,K-N);
	p_dist = zeros(1, a_max+1);
	if rem(N,2) == 0
		p_dist(1) = leading_coefficient / (factorial(N/2) * factorial((K-N)/2));
	else
		p_dist(2) = leading_coefficient * 2 / (factorial((N-1)/2) * factorial((K - N - 1)/2));
	end
	
	for a = offset:2:(a_max - 2)
		p_dist(a+2+1) = p_dist(a+1) * (N - a) * (K - N - a) / ((a + 1)*(a + 2));
	end
end

function sampled_index = sample(D)
	r = rand();
	x = 0.0;
	for i = 1:length(D)
		x += D(i);
		if x > r
			sampled_index = i;
			break
		end
	end
end

function results = runthrough(K, N_0, T)
	results = zeros(1, T+1);
	results(1) = N_0;
	for i = 1:T
		results(i+1) = results(i) + (sample(p_dist(K, results(i))) - 1);
	end
end

n_runthroughs = 1000
t_max = 10
N_0 = 5
K = 200

runthrough(20, 7, t_max)

covering_matrix = zeros(K+1, t_max+1);

figure
hold on
for i = 1:n_runthroughs
	current_runthrough = runthrough(K, N_0, t_max);
	for j = 1:(t_max + 1)
		covering_matrix(K-current_runthrough(j)+1, j) += 1;
	end
	plot(current_runthrough)
end	
print("lines.png")
hold off

clf
