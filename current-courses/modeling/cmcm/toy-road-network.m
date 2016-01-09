flux_matrix = [ -1  1  0 -1  0  0;...
                 0 -1 -1  0 -1  0;...
				 1  0  1  0  0  1;...
				 0  0  0  1  1 -1 ];

null(flux_matrix)

exit_flows = [ 6000; 7000; 0; 0];

populations = [ 43924; 187105; 139668; 125932];

max_flows = [2000; 2000; 3000; 3000; 2000; 100];

%objective_function = [1; 0; 1; 1; 1; 0];
objective_function = [0; 0; 0; 0; 0; 0];

optimal_flows = get_optimal_flows_linprog(exit_flows, flux_matrix, max_flows, populations, objective_function)
