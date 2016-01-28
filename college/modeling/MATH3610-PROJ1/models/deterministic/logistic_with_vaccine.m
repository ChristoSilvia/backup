global r = 1.0;
global K = 1.0;
global r_v = 0.2;
global s_0 = 0.05;

function s = s(t)
	global r; global K; global r_v; global s_0;
	s = exp(r.*t.*(K - r_v .* t ./ 2)) ./ (1 ./ s_0 + sqrt(pi .* r ./ (2 * r_v)) .* exp( 0.5 * r ./ r_v .* K.^2) .* ( erf( sqrt(0.5 * r ./ r_v) .* (r_v .* t - K)) - erf(- sqrt(0.5 * r ./ r_v) .* K)));
end

T = 0:0.02:K/r_v;
A = 0.2:0.1:4.0;
S = zeros(length(T), length(A)+1);
S(:,1) = T;
hold on
for i = 2:(length(A)+1)
	r = A(i-1);
	S(:,i) = s(T);
	j = 1;
	while S(j,i) < K - r_v * T(j)
		j = j + 1;
	end
	S((j+1):length(T), i) = S(j,i);
	plot(T(1:j), S((1:j),i));
	plot(T((j+1:length(T))), S(j,i)*ones(1,length(T)-j));
end
plot(T, K - r_v * T);
hold off
axis([0,6,0,1])
csvwrite("data/s.csv", S);
title("Different Values of R");
print("vaccine.png")
length(A(1,:)-1)
pause
