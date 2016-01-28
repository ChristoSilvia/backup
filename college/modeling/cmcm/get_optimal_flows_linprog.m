function [final_time, ideal_flows] = get_optimal_flows(exit_flows, flux_matrix, max_flows, populations, objective_function) 

pkg load optim
% CHECK IF WELL POSED

bound_on_outflow = abs(flux_matrix) * max_flows
if sum(exit_flows > bound_on_outflow)
	[ _, i_problem ] = max(bound_on_outflow < exit_flows);
	error(sprintf('exit flows cannot be achieved on node %d, please restate problem', i_problem))
end

% DEFINE AUXILIARY QUANTITIES

n_nodes = length(populations);
n_links = length(max_flows);

final_time = sum(populations,1)/sum(exit_flows,1)

% MAKE INITIAL TRY

printf('finding ideal flow amounts\n')

max_flows
ideal_flows_from_pseudoinverse = flux_matrix \ (populations/final_time - exit_flows)

if n_links > n_nodes
	nullspace = null(flux_matrix);
	[_, dim_nullspace] = size(nullspace);

	% convert objective function on roads into objective function on nullspace coeffs
	nullspace_objective = nullspace' * objective_function;

	% total magnitude must obey constraints in positive and negative
	linprog_A = [nullspace; -nullspace];
	linprog_b = [max_flows - ideal_flows_from_pseudoinverse;...
                 max_flows + ideal_flows_from_pseudoinverse];

	%
	nullspace_coefficients = linprog(nullspace_objective, linprog_A, linprog_b)
	ideal_flows = ideal_flows_from_pseudoinverse + nullspace * nullspace_coefficients;
elseif n_links < n_nodes
	left_behind = populations - (flux_matrix * ideal_flows_from_pseudoinverse + exit_flows)*final_time;
	if norm(left_behind) > 1
		error('no solution exists, not enough edges\n')
	else
		ideal_flows_from_pseudoinverse = ideal_flows_from_pseudoinverse;
	end
else
	ideal_flows = ideal_flows_from_pseudoinverse;
end


% CHECK IF IT SOLVES THE PROBLEM

left_behind = abs(populations - (flux_matrix * ideal_flows + exit_flows)*final_time)

end
