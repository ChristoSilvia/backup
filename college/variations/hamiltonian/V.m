function v = V(q)
	global m1; global m2;
	global g;
	global d1; global d2;
	global l1; global l2;

	v = m1*g*d1*sin(q(1)) + m2*g*(l1*sin(q(1)) + d2*sin(q(1) + q(2)));
end
