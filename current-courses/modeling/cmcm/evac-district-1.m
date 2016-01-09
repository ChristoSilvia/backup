n_nodes = 13;
n_edges = 19;

% FLUX MATRIX
%                1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
flux_matrix = [  1  0 -1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0;...%1
                 0  0  1  0  0  1  1  0  0  0  0  0  0  0  0  0  0  0  0;...%2
		         0  0  0  0  1 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0;...%3
				 0 -1  0 -1 -1  0  0  0  1  0  0  0  0  0  0  0  0  0  0;...%4
				 0  0  0  0  0  0 -1  1  0  1  1  0  0  0  0  0  0  0  0;...%5
				 0  0  0  0  0  0  0  0  0  0 -1  0  1 -1  0  0  0  0  0;...%6
				 0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  1  1  0  0;...%7
				 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0  1;...%8
				 0  0  0  0  0  0  0  0 -1 -1  0 -1  0  0  0  0  0  0  0;...%9
				 0  0  0  0  0  0  0  0  0  0  0  1 -1  0  1  0  0  0  0;...%10
				 0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1 -1  0;...%11
				 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1 -1;...%12
				-1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0]; %13


% COMPUTE PERSONS PER HOUR FLOW ON ROADS

%         1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
lanes = [ 1; 1; 1; 2; 1; 1; 3; 1; 1; 2; 3; 1; 2; 3; 1; 3; 1; 1; 2];

%                        1  2  3  4  5  6  7  8  9 10 11 12 13
region_exits_n_lanes = [ 0; 0; 0; 2; 0; 0; 0; 0; 3; 0; 1; 2; 1];

% from website
n_cars_per_lane_per_hour = 1900;
max_cars_per_hour = n_cars_per_lane_per_hour * lanes;
max_cars_through_region_exits = n_cars_per_lane_per_hour * region_exits_n_lanes;

avg_household_size = 2.65;
% I KNOW THAT THE NUMBER OF CARS IS NOT THIS

node_populations = [ 26393;...%  1
                     43953;...%  2 
					  1996;...%  3
					 18507;...%  4
					130461;...%  5
					 68598;...%  6
					 65759;...%  7
					 75377;...%  8
					 15199;...%  9
					  2676;...% 10
					  6762;...% 11
					 16541;...% 12
				     10388];  % 13

node_car_populations = node_populations / avg_household_size;

[final_time, optimal_flows] = get_optimal_flows_linprog(max_cars_through_region_exits, flux_matrix, max_cars_per_hour, node_car_populations, zeros(n_edges, 1));

printf('Final Time: %f\n',final_time);
printf('\n');
printf('Edge |  Flow      |  Bound \n');
printf('-----------------------------\n');
for i = 1:n_edges
	printf(' %02d  |  %8.2f  |  %8.2f \n', i, optimal_flows(i), max_cars_per_hour(i))
end


