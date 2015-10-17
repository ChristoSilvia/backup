eigs([-1.1 0.1 1; 1 -1.1 0.1; 0.1 1 -1.1])
pkg load odepkg;

global R = [-1.1 0.1 1; 1 -1.1 0.1; 0.1 1 -1.1];
[vectors, values] = eig(R);

function [derivs, jacobian] = f(t, x)
	global R;
	derivs = R * x;
	jacobian = R;
end

[T, X] = ode45(@f, [0, 10], [0.05; 0.05; 1.0])

csvwrite('lake-cycles.csv',[T X])

plot(T,X)
legend('Lake 1', 'Lake 2', 'Lake 3')
pause

R = [ -0.01 0 0 0 0 0.01; 0.01 -0.01 0 0 0 0] 
