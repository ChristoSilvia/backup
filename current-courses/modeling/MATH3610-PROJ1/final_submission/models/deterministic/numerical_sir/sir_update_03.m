function [y_prime] = sir_update_03(y,beta,nu,mu,gamma)
s = y(1); 
i = y(2);
if s <= 0
    gamma = 0;
end
y_prime = zeros(3,1);

y_prime(1) = -beta * s * i - gamma;
y_prime(2) = i * (beta * s - nu - mu);
y_prime(3) = nu * i + gamma;
y_prime(4) = mu * i;
end

