function xs = ifft(ks)
% ks is a column vector of length n = 2^k
n = length(ks);

if n == 1
  xs = ks;
else
  evens = ifft(ks(1:2:n));
  odds = ifft(ks(2:2:n));
  xs = zeros(n,1);
  for m = 1:n/2
    w = exp(2 * pi * j * (m-1) / n);
    xs(m) = (evens(m) + w*odds(m))/(n/2);
    xs(m+n/2) = (evens(m) - w*odds(m))/(n/2);
  end
end

end
