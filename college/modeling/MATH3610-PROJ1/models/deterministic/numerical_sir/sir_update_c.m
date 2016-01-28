function [y_prime] = sir_update_04(y,beta,nu,mu,gamma)
s = y(1:3);
i = y(4:6);

y_prime = zeros(9,1);
for k = 1:3
    y_prime(k) = -beta(k,:) * i * s(k) - gamma(k);
    y_prime(k+3) = beta(k,:) * i * s(k) - i(k) * (nu + mu(k));
    y_prime(k+9) = nu * i(k) + gamma(k);
    y_prime(k+12) = mu(k) * i(k);
end

end
