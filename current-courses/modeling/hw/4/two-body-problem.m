function xdot = two_body(x, t)
	xdot = [x(3:4); -x(1:2)/norm(x(1:2))^3];
end

X = lsode(@two_body, [1; 0; 0; 0.25], linspace(0, 2*pi, 1000))

plot(X(:,3), X(:,4))
title("Dimensionless Planetary Motion Velocities, x_0 = (1, 0), v_0 = (0, 0.25)")
print("plots/veolcity-planet-motion.png")
pause
