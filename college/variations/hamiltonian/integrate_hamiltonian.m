function derivatives = integrate_hamiltonian(x)
	global n;
	q = reshape(x(1:n),n,1);
	p = reshape(x((n+1):2*n),n,1);

	q_dot = inv(K(q)) * p;
	grad_k = Grad_K(q);
	p_dot = -Grad_V(q);
	for i = 1:n
		p_dot(i) += 0.5 * q_dot' * grad_k(i) * q_dot;
	end
	derivatives = [q_dot; p_dot];

	printf('Energy: %f\n', 0.5 * q_dot' * K(q) * q_dot + V(q))
end
