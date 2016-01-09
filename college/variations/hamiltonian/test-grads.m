q = 2*pi*rand(2,1)
eps = 1e-5

(K(q + [eps; 0.0]) - K(q))/eps

Grad_K(q)


