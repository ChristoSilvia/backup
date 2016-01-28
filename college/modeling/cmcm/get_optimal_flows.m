function complete_ideal_flows = get_optimal_flows(exit_flows, flux_matrix, max_flows, populations) 

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

original_flux_matrix = flux_matrix;
original_exit_flows = exit_flows;

fixed_flows = zeros(n_links,1);

% MAKE INITIAL TRY

printf('finding ideal flow amounts\n')

ideal_flows = flux_matrix \ (populations/final_time - exit_flows)

while (sum(abs(ideal_flows) > max_flows(fixed_flows == 0)) ~= 0)
	% find the first flow which exceeds the desired limits
	% IMPORTANT: adjust i_first_current_length so that it's in line with the ORIGINAL indexing
	[_, i_first_current_length] = max(abs(ideal_flows) > max_flows(fixed_flows == 0));
	i_first_fixed_length = i_first_current_length + cumsum(abs(fixed_flows))(i_first_current_length);

	printf('\nLink %d (current) / %d (fixed) exceeded the flow limit %f with %f\n', i_first_current_length, i_first_fixed_length, max_flows(i_first_fixed_length), ideal_flows(i_first_current_length));

	% record a saturated road and its direction in fixed_flows
	fixed_flows(i_first_fixed_length) = sign(ideal_flows(i_first_current_length));

	% remove the saturated row from the flux matrix
	flux_matrix = original_flux_matrix(:,fixed_flows==0);
	printf('Updated Flux Matrix by removing column corresponding to link %d\n', i_first_fixed_length);

	% add the flow to the exit flows vector
	new_flows = original_flux_matrix(:,i_first_fixed_length) * (sign(ideal_flows(i_first_current_length)) * max_flows(i_first_fixed_length));
	exit_flows += new_flows;
	[out_flow, i_out] = min(new_flows);
	[in_flow, i_in] = max(new_flows);
	printf('Recorded saturated link as a fixed flow of %f out of node %d, and a fixed flow of %f into node %d\n', in_flow, i_in, -out_flow, i_out);

	% solve the updated linear system
	if length(ideal_flows) > n_nodes
		printf('Computed new ideal flows for updated system\n');
		ideal_flows = flux_matrix\(populations/final_time - exit_flows)
	else
		printf('Computed ideal flows for part of system, checking if valid for the rest\n');
		ideal_flows = flux_matrix(1:length(ideal_flows),:)\(populations(1:length(ideal_flows))/final_time - exit_flows(1:length(ideal_flows)))
		n_not_evacuated_for_nodes_not_in_previous = (flux_matrix(length(ideal_flows)+1:end,:)*ideal_flows + exit_flows(length(ideal_flows)+1:end))*final_time
		if n_not_evacuated_for_nodes_not_in_previous > 1.0
			error('no evacuation strategy possible\n')
		end
	end
end

complete_ideal_flows = zeros(n_links,1);
i_ideal_flows = 1;
for i = 1:n_links
	if fixed_flows(i) ~= 0
		complete_ideal_flows(i) = fixed_flows(i) * max_flows(i);
	else
		complete_ideal_flows(i) = ideal_flows(i_ideal_flows);
		i_ideal_flows += 1;
	end
end

% CHECK IF IT SOLVES THE PROBLEM

complete_ideal_flows
left_behind = abs(populations - (original_flux_matrix * complete_ideal_flows + original_exit_flows)*final_time)
end
