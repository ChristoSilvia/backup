n = 21;
x = linspace(0,1,n);
y = zeros(1,n);
for k = 1:n
  y(k) = sin(2*pi*x(k))
end
plot(x,y)
title('A title')
xlabel('A label')
ylabel('A Nother Label');
