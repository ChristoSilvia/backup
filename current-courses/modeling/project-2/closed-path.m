w = 4;
h = 4;


A = [1 2; 1 3; 1 3]
a = [1 2]
prod(any(a == A))

function path = get_path(w,h, partial_path)
    if length(partial_path(:,1)) == w*h
		path = 0;
		if partial_path(end,1) == partial_path(1,1) + 1 && partial_path(end,2) == partial_path(1,2)
			path = [partial_path; partial_path(1,:)];
		end
		if partial_path(end,1) == partial_path(1,1) - 1 && partial_path(end,2) == partial_path(1,2)
			path = [partial_path; partial_path(1,:)];
		end
		if partial_path(end,1) == partial_path(1,1) && partial_path(end,2) == partial_path(1,2) + 1
			path = [partial_path; partial_path(1,:)];
		end
		if partial_path(end,1) == partial_path(1,1) && partial_path(end,2) == partial_path(1,2) - 1
			path = [partial_path; partial_path(1,:)];
		end
	else
		path = 0;


		if partial_path(end,1) < w && any((partial_path(end,1) + 1 == partial_path(:,1)) .* (partial_path(end,2) == partial_path(:,2))) == 0
			right_path = get_path(w,h, [partial_path; partial_path(end,:) + [1,0]]);
			if right_path != 0
				path = right_path;
			end
		end
		if partial_path(end,1) > 1 && path == 0  && any((partial_path(end,1) - 1 == partial_path(:,1)) .* (partial_path(end,2) == partial_path(:,2))) == 0
			left_path = get_path(w,h, [partial_path; partial_path(end,:) + [-1,0]]);
			if left_path != 0
				path = left_path;
			end
		end
		if partial_path(end,2) < h && path == 0 && any((partial_path(end,1) == partial_path(:,1)) .* (partial_path(end,2) + 1 == partial_path(:,2))) == 0
			up_path = get_path(w, h, [partial_path; partial_path(end,:) + [0,1]]);
			if up_path != 0
				path = up_path;
			end
		end
		if partial_path(end,2) > 1 && path == 0 && any((partial_path(end,1) == partial_path(:,1)) .* (partial_path(end,2) - 1 == partial_path(:,2))) == 0
			down_path = get_path(w, h, [partial_path; partial_path(end,:) + [0,-1]]);
			if down_path != 0
				path = down_path;
			end
		end
	end
end

w = 6;
h = 6;
a = get_path(w,h,[1,1])
plot(a(:,1),a(:,2))
axis([0,w+1,0,h+1])
pause
