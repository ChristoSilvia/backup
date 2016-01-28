A = 23309584;
r = 300;
v = 16;
foft = 0.95;
t = 900;

n_float = log(1.0 - foft)./(log(1.0 - (pi*r.^2 + 2 * r .* v .* t)/A))
n = ceil(n_float);

V = linspace(0,30);
FofT = 1.0 - (1 - (pi*r.^2 + 2*r.*V.*t)/A).^n
plot(V,FofT)
csvwrite('robustness.csv',[V' FofT'])
pause
