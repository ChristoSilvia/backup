max_tickets =5

format long
storage = zeros(min(2,max_tickets),max_tickets,max_tickets,max_tickets)

n_1200000 = 1;
n_30 = 4000;
n_800 = 500;
n_0 = 2000000 - 1 - 500 - 4000;

total_permutations = 0;
for n_1200000_chosen = 0:1
	for n_0_chosen = 0:(max_tickets - n_1200000_chosen)
		for n_30_chosen = 0:(max_tickets - (n_1200000_chosen + n_0_chosen))
			n_800_chosen = max_tickets - (n_1200000_chosen + n_0_chosen + n_30_chosen);
			nchoosek(n_800, n_800_chosen) * nchoosek(n_30,n_30_chosen) * nchoosek(n_0,n_0_chosen)
			n_permutations = nchoosek(n_800, n_800_chosen) * nchoosek(n_30,n_30_chosen) * nchoosek(n_0,n_0_chosen);
			expected_value = n_1200000_chosen * 1200000 + n_30_chosen * 30 + n_800_chosen * 800;
			[n_1200000_chosen,n_0_chosen,n_30_chosen,n_800_chosen ]
			storage(n_1200000_chosen+1,n_0_chosen+1,n_30_chosen+1,n_800_chosen+1) = n_permutations * expected_value;
			total_permutations += n_permutations;
		end
	end
end

%storage
%storage/total_permutations
sum(storage(:))/total_permutations
