global rpp = 0.1;
global rcp = 0.3;
global rpc = 0.4;
global rcc = 1.0;
global kc_0 = 1;
global kp_0 = 2;

global vr_c = 0.2;
global vr_p = 0.8;

function result = f(X, t)
	global rpp; global rcp; global rpc; global rcc; global kc_0; global kp_0;
	global vr_c; global vr_p;
    P = X(1);
	C = X(2);
	result = [ rpp*P*(kp_0 - P) + rcp*(kp_0 - P)*C; rpc*(kc_0-C)*P + rcc*(kc_0-C)*C];
end

T = linspace(0, 10, 1000);

results = lsode(@f, [0.01; 0.0], T);
hold on
%plot(T, results(:,1));
%plot(T, results(:,2));
hold off
plot(results(:,1), results(:,2));
pause
