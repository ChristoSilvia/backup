function p_dist = p_dist(N_m,N_f)
	leading_coefficient = factorial((N_m + N_f)/2) / nchoosek(N_m + N_f, N_m);
	offset = (rem(N_m,2) != 0);
	
	% a_max is N if a is even, N-1 if a is odd.

	a_max = min(N_f, N_m);
	p_dist = zeros(1, a_max+1);
	if rem(N_m,2) == 0
		p_dist(1) = leading_coefficient / (factorial(N_m/2) * factorial(N_f/2));
	else
		p_dist(2) = leading_coefficient * 2 / (factorial((N_m-1)/2) * factorial((N_f - 1)/2));
	end
	
	for a = offset:2:(a_max - 2)
		p_dist(a+2+1) = p_dist(a+1) * (N_m - a) * (N_f - a) / ((a + 1)*(a + 2));
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

function results = runthrough(N_m_0, N_f_0, d, p, f, T)
	results = zeros(2, T+1);
	results(:,1) = [N_m_0, N_f_0];
	for i = 1:T
		if (results(1,i) > 0) && (results(2,i) > 0)
			if (rem(results(1,i) + results(2,i), 2) != 0)
				odd_one_out = sample([ results(1,i), results(2,i)] / (results(1,i) + results(2,i)))
				if odd_one_out == 1
					if results(1,i) == 1
						n_meetings = 0
					else
						results(1,i)-1
						results(2,i)
						n_meetings = sample(p_dist(results(1,i)-1, results(2,i)))-1;
					end
				else
					if results(2,i) == 1
						n_meetings = 0
					else
						results(1,i)
						results(2,i)-1
						n_meetings = sample(p_dist(results(1,i), results(2,i)-1))-1
					end
				end
			else
				results(1,i)
				results(2,i)
				n_meetings = sample(p_dist(results(1,i), results(2,i)))-1;
			end
			n_meetings
			n_pregnancies = sample(binopdf([0:n_meetings], n_meetings, p))-1;
		else
			n_pregnancies = 0;
		end
		n_male_fight_deaths = sample(binopdf([0:floor((results(1,i) - n_meetings)/2)], floor((results(1,i) - n_meetings)/2), f)) -1;
		n_male_deaths = sample(binopdf([0:(results(1,i) - n_male_fight_deaths)], results(1,i) - n_male_fight_deaths, d))-1;
		n_pregnant_female_deaths = sample(binopdf([0:n_pregnancies], n_pregnancies, d))-1;
		n_nonpregnant_female_deaths = sample(binopdf([0:(results(2,i) - n_pregnancies)], results(2,i) - n_pregnancies, d))-1;
		n_female_deaths = n_pregnant_female_deaths + n_nonpregnant_female_deaths;
		n_babies = n_pregnancies - n_pregnant_female_deaths;
		n_male_babies = sample(binopdf([0:n_babies], n_babies, 0.5))-1;
		n_female_babies = n_babies - n_male_babies;
		- [ n_male_deaths + n_male_fight_deaths ; n_female_deaths] + [n_male_babies; n_female_babies]
		results(:,i+1) = results(:,i) - [ n_male_deaths + n_male_fight_deaths ; n_female_deaths] + [n_male_babies; n_female_babies];
	end
end

t_max = 200
n_trials = 20
hold on
for i = 1:n_trials
	pops = runthrough(20, 40, 0.1, 0.6, 0.8, t_max)
	plot([0:t_max], pops(1,:), ";males;")
	plot([0:t_max], pops(2,:), ";females;")
end
hold off
legend(
pause)


%	n_runthroughs = 1000
%	t_max = 10
%	N_0 = 5
%	K = 200
%	
%	runthrough(20, 7, t_max)
%	
%	covering_matrix = zeros(K+1, t_max+1);
%	
%	figure
%	hold on
%	for i = 1:n_runthroughs
%		current_runthrough = runthrough(K, N_0, t_max);
%		for j = 1:(t_max + 1)
%			covering_matrix(K-current_runthrough(j)+1, j) += 1;
%		end
%		plot(current_runthrough)
%	end	
%	print("lines.png")
%	hold off
%	
%	clf
