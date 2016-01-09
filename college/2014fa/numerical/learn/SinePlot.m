% Script File: SinePlot
% Displays increasingly smooth plots of sin(2*pi*x)
close all
for n = [4 8 12 16 50 100 200 400]
  x = linspace(0,1,n);
  y = sin(2*pi*x);
  plot(x,y)
  title(sprintf('Plot of sin(2*pi*x) based on n = %3.d of points',n))
  pause(1)
end
