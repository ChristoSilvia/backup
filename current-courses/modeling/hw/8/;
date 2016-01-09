function [eigvec, eigval] = eigvec(r)
	A = setup_a(r);

	[v,d]=eig(A);
	[eigval,j] = max(abs(diag(d)));
	eigvec = v(:,j)/sum(v(:,j));
end

hold on
for r = 0.1:0.1:1.0
	[r_eigvec, r_eigval] = eigvec(r);
	plot(r_eigvec, 'color', [r 0 1-r], sprintf(';r=%f, eigval=%f;',r,r_eigval));
end
legend()
title('Population Distributions for Scaled Natality Rates');
hold off
print('population-distributions.png')
pause

