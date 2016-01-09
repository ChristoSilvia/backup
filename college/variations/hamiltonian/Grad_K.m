function [Grad_1 Grad_2] = Grad_K(q)
	global m1; global m2; % arm masses
	global I1; global I2; % arm moments of inertia
	global l1; global l2; % arm lengths
	global d1; global d2; % distances to arm CM's
	n = length(q);
	Grad_1 = zeros(2,2); 
	Grad_2 = [ -m2*2*l2*d2*sin(q(2)) -m2*d2*l2*sin(q(2)); -m2*d2*l2*sin(q(2)) 0.0 ];
end	
