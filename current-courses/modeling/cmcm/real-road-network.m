n_nodes = 14;
n_edges = 20;

% FLUX MATRIX
%                1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
flux_matrix = [ -1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;...%1
                 1  0  0  0  0  0  0  1  0  0  0  1  0  0  0  0  0  0  0  0;...%2
		         0  0  1  0  0  0 -1  0  0  0  0 -1  0  0  0  0  0  0  0  0;...%3
				 0 -1 -1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;...%4
				 0  0  0  0  0  1  1 -1  1  0  0  0  0  0  0  0  0  0  0  0;...%5
				 0  0  0  0  0  0  0  0 -1  1  1  0  0  0  0  0  0  0  0  0;...%6
				 0  0  0  0  0  0  0  0  0 -1  0  0  1  0  0  0  1  0  0  0;...%7
				 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  1  0  0;...%8
				 0  0  0  0  1 -1  0  0  0  0  0  0  0  1  0  0  0  0  0  0;...%9
				 0  0  0  0  0  0  0  0  0  0 -1  0  0 -1  1  0  0  0  0  0;...%10
				 0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  1  0  0  0  0;...%11
				 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  1  0;...%12
				 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0 -1  1;...%13
				 0  0  0 -1 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1]; %14


% COMPUTE PERSONS PER HOUR FLOW ON ROADS

%         1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
lanes = [ 1; 2; 1; 2; 2; 2; 1; 3; 3; 3; 2; 1; 1; 1; 1; 1; 3; 2; 2; 2];

%                        1  2  3  4  5  6  7  8  9 10 11 12 13 14
region_exits_n_lanes = [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 2; 0; 4];

% from website
n_cars_per_lane_per_hour = 1600;
max_cars_per_hour = n_cars_per_lane_per_hour * lanes;
max_cars_through_region_exits = n_cars_per_lane_per_hour * region_exits_n_lanes;

avg_household_size = 2.77;
% I KNOW THAT THE NUMBER OF CARS IS NOT THIS
max_persons_per_hour = avg_household_size * max_cars_per_hour;
max_persons_through_region_exits_per_hour = avg_household_size * max_cars_through_region_exits;

node_populations = [ 31523;...%  1
                     43953;...%  2 
					  1996;...%  3
					 23701;...%  4
					130461;...%  5
					 68598;...%  6
					 65759;...%  7
					 75377;...%  8
					 15199;...%  9
					  2676;...% 10
					  6762;...% 11
					 16541;...% 12
					  6128;...% 13
				    147433];  % 14

optimal_flows = get_optimal_flows_linprog(max_persons_through_region_exits_per_hour, flux_matrix, max_persons_per_hour, node_populations);
[(1:20)' optimal_flows]

