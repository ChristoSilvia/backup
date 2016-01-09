flux_matrix = [ -1  1  0 -1  0  0;...
                 0 -1 -1  0 -1  0;...
				 1  0  1  0  0  1;...
				 0  0  0  1  1 -1 ];

exit_flows = [ 3000; 2000; 0; 0];

populations = [ 10000; 15000; 5000; 17000];

max_flows = [1000;2000;500;1000;2000;500];

objective_function = [0; 0; 0; 0; 0; 0];

final_time = sum(populations)/sum(exit_flows);

K = null(flux_matrix)
pseudoinverse = flux_matrix\(populations/final_time - exit_flows)

