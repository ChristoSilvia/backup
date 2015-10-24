n = 100;
r = 40;
s = 30;
m = 100;

p = 0.6;
q = 0.3;

k_opt = log((s/(n-r)) * log(1-q)/log(1-p))/log((1-p)/(1-q));
if (k_opt > 0) && ((n-r)*(1 - (1 - p).^k_opt) - s*(1 - (1 - q).^k_opt) > 0)
	DS_k_opt_floor = (n-r)*(1 - (1 - p).^floor(k_opt)) - s*(1 - (1 - q).^floor(k_opt))
	DS_k_opt_ceil = (n-r)*(1 - (1 - p).^ceil(k_opt)) - s*(1 - (1 - q).^ceil(k_opt))
	if DS_k_opt_floor > DS_k_opt_ceil
		k_opt_int = floor(k_opt)
	else
		k_opt_int = ceil(k_opt)
	end
else
	if (n - r) - s > 0
		k_opt_int = Inf;
	else
		k_opt_int = 0;
	end
end

K = linspace(0,10,1000);

figure; hold on;

plot(K, (n-r)*(1 - (1 - p).^K) - s*(1 - (1 - q).^K),'color','red')
plot(k_opt, (n-r)*(1 - (1 - p).^k_opt) - s*(1 - (1 - q).^k_opt),'color','green')
plot(k_opt_int, (n-r)*(1 - (1 - p).^k_opt_int) - s*(1 - (1 - q).^k_opt_int),'color','green')


n_iterations = 1000;
monte_carlos_s = zeros(n_iterations, k_opt_int+1);
monte_carlos_nmr = zeros(n_iterations, k_opt_int+1);
monte_carlos_s(:,1) = s;
monte_carlos_nmr(:,1) = n-r;
for j = 1:n_iterations
	for i = 2:(k_opt_int+1)
		monte_carlos_s(j,i) = monte_carlos_s(j,i-1) - sum(rand(1,monte_carlos_s(j,i-1)) > p);
		monte_carlos_nmr(j,i) = monte_carlos_nmr(j,i-1) - sum(rand(1,monte_carlos_nmr(j,i-1)) > q);
	end
	plot(0:k_opt_int,  ((n-r) - monte_carlos_nmr(j,:)) - (s-monte_carlos_s(j,:)),'color','blue')
end

mu = mean(((n-r) - monte_carlos_nmr(:,end)) - (s-monte_carlos_s(:,end)))
sigma = std(((n-r) - monte_carlos_nmr(:,end)) - (s-monte_carlos_s(:,end)))
sigma_theoretical = sqrt((n-r)*((1-p).^k_opt_int)*(1 - (1 - p).^k_opt_int) + s*(1 - q).^k_opt_int*(1 - (1 - q).^k_opt_int))
%	hist(((n-r) - monte_carlos_nmr(:,end)) - (s-monte_carlos_s(:,end)), 16)

hold off;
title(sprintf('Politician Problem, n=%d, r=%d, s=%d, m=%d, p=%f, q=%f, k_opt=%f, k_opt_int=%d',n,r,s,m,p,q,k_opt,k_opt_int))
print('politician-plot.png')
pause
