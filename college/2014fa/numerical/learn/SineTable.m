% Script File: SineTable
% Prints a short table of sine evaluations

clc
n = 21;
x = linspace(0,1,n);
y = sin(2*pi*x);
disp(' ')
disp(' l     x(k)     sin(x(k))')
disp('-------------------------')
for k=1:21
  degrees = (k-1)*360/(n-1);
  disp(sprintf(' %2d     %3f     %6f   ',k,degrees,y(k)));
end
disp(' ');
disp('x(k) is given in degrees')
disp(sprintf('One Degree = %5.3e Radians',pi/180))
