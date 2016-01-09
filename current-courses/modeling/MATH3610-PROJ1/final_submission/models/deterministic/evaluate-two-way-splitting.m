global n_staff = 6000;
global n_students = 25000;
global n_ithacans = 22000;

% entry 
global beta = ;
global gamma = 

function derivs = f(t, x)
	global n_staff; global n_students; global n_ithacans;
	I = x(1:3); S = x(4:6); R = x(7:9);
	
