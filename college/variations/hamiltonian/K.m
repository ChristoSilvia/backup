function K_matrix = K(q)
	global m1; global m2; % arm masses
	global I1; global I2; % arm moments of inertia
	global l1; global l2; % arm lengths
	global d1; global d2; % distances to arm CM's
	K_matrix = [ (m1*d1.^2 + m2*(d2.^2 + l2.^2 + 2*l2*d2*cos(q(2))) + I1 + I2) (m2*(d2.^2 + d2*l2*cos(q(2))) + I2); (m2*(d2.^2 + d2*l2*cos(q(2))) + I2) (m2*d2.^2 + I2)];
end	
