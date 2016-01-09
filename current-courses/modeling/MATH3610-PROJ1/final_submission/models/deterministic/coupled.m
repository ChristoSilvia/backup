global r11 = 1.0;
global r22 = 0.8;
global r33 = 2.0;
global r12 = 0.2;
global r21 = 0.2;
global r23 = 0.3;
global r32 = 0.3;


global ak1 = 0.4;
global ak2 = 0.3;
global ak3 = 0.1;

pkg load odepkg

function derivs = f( t, I)
	global r11; global r12; global r21;
	global r22; global r23; global r32;
	global r33; global ak1; global ak2;
	global ak3;

	derivs = zeros(1,3);
	derivs(1) = (r11 * I(1) + r12 * I(2)).*(1.0 - I(1) - ak1 * t);
	derivs(2) = (r21 * I(1) + r22 * I(2) + r23 * I(3) ) .* (1.0 - I(2) - ak2 * t);
	derivs(3) = (r23 * I(2) + r33 * I(3)) .* (1.0 - I(3) - ak3 * t);
end

T = linspace(0,6);
[J, X] = ode45(@f, T, [0.02; 1e-8; 1e-8]);
X
i = 1;
while (i < length(T)) && (X(i,1) + ak1 * T(i) < 1) && (X(i,2) + ak2 * T(i) < 1) && (X(i,3) + ak3 * T(i) < 1)
	i= i + 1;
end
X(1:i,:)
hold on
plot(T(1:i), X(1:i,1), "color", "r", ";Ithaca;")
plot(T(1:i), X(1:i,2), "color", "g", ";Faculty and Staff;")
plot(T(1:i), X(1:i,3), "color", "b", ";Students;")
legend("location", "northwest")
hold off
pause
