function ks = fft(xs)
% xs is a column vector of length n = 2^k
n = length(xs);

if n == 1
  ks = xs;
else
  evens = fft(xs(1:2:n));
  odds = fft(xs(2:2:n));
  ks = zeros(n,1);
  for m=1:n/2
    w = exp(- 2 * pi * j * (m-1) / n);
    ks(m) = evens(m) + w*odds(m);
    ks(m+n/2) = evens(m) - w*odds(m);
  end
end

end
