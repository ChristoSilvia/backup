global A = 3.0 * 2.0;
global r = 0.1;
global v = 1.0;

function p = p(t,n)
	global A; global r; global v;
	p = 1 - (1 - (pi*r.^2 + 2*r*(v*t))./A).^n;
end

t_max_effective = (A - pi*r.^2)/(2*v*r)
T = linspace(0,t_max_effective/2);

M = zeros(length(T),20)

hold on
for i = 1:20
	M(:,i) = p(T,i);
	plot(T,p(T,i));
end
hold off
title('pn-curves')
print('pn-curves.png')
csvwrite('pn-curves.csv', [T' M])
pause

