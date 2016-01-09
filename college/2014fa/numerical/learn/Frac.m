function q = Frac(n,h)

% Computes two numbers, [ a; b], such that a/b is within h of n.
% Expect input to be between 0 and 1.

a = 0;
b = 1;
while (abs(a/b - n) > h)
  while (a/b < n)
    a = a + 1;
    b = b + 1;
  end
  while (a/b > n)
    b = b + 1;
  end
end

q = [a;b]
