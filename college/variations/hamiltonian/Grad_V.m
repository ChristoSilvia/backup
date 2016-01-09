function grad_v = Grad_V(q)
	global m1; global m2;
	global g;
	global d1; global d2;
	global l1; global l2;

	grad_v = [ g*(m1*d1*cos(q(1)) + m2*(l1*cos(q(1)) + d2*cos(q(1) + q(2))));g*m2*d2*cos(q(1) + q(2))]; 
end
