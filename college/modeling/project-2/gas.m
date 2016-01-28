w = 2.0;
h = 3.0;
r = 0.1;

eps = 1e-5;

v = randn(1,2);
x = [0.8 0.3];

n_steps = 100;
X = zeros(n_steps+1,2);

X(1,:) = x;
t = 0;
for i = 1:n_steps
	t_left_wall_collision = (r - x(1))./v(1);
	t_right_wall_collision = (w - r - x(1))./v(1);
	t_bottom_wall_collision = (r - x(2))./v(2);
	t_top_wall_collision = (h - r - x(2))./v(2);

	t_so_far = Inf;
    if t_left_wall_collision > eps && t_left_wall_collision < t_so_far
		t_so_far = t_left_wall_collision;
		which_wall = 1;
	end
    if t_right_wall_collision > eps && t_right_wall_collision < t_so_far
		t_so_far = t_right_wall_collision;
		which_wall = 2;
	end
    if t_bottom_wall_collision > eps && t_bottom_wall_collision < t_so_far
		t_so_far = t_bottom_wall_collision;
		which_wall = 3;
	end
    if t_top_wall_collision > eps && t_top_wall_collision < t_so_far
		t_so_far = t_top_wall_collision;
		which_wall = 4;
	end
	
	x += v * t_so_far;
	t += t_so_far;
	X(i+1,:) = x;

	if (which_wall == 1) || (which_wall == 2)
		v(1) *= -1;
	else
		v(2) *= -1;
	end
end

plot(X(:,1),X(:,2))
pause
