function [y_prime] = sir_update_02(y,beta,nu,mu)
s = y(1); 
i = y(2);
y_prime = zeros(3,1);
y_prime(1) = -beta * s * i;
y_prime(2) = i * (beta * s - nu - mu);
y_prime(3) = nu * i;
y_prime(4) = mu * i;
end

