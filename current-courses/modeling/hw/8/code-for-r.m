function eigval = eigval(r)
	A = setup_a(r);	
	
	[v,d]=eig(A);
	[eigval,j] = max(abs(diag(d)));
end 

r_steady_population = fzero(@(r) eigval(r) - 1.0, 0.5);
printf('R Value for non-shrinking population: %f\n', r_steady_population)

