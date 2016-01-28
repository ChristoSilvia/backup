% The chemical dissolving in interconnected "lakes" problem.
%
% Our basic assumption is that the volume of each "lake" 
% stays constant.  Can you re-write the system of ODEs to
% handle the more general case?


%initial concentrations of chemicals in each lake
c0 = [1;0;1;0;0;0];
%c0 = [3;0;0;0;1;0];
%c0 = [2;0;0;0;1;0];


n = length(c0); %the number of lakes

% The volumes of lakes in km^3
V = ones(1,n);

% The mutal flow rates matrix
% r(i,j) = # of (km^3) of water passing from lake j to lake i per day.
%
% Note: all entries are non-negative (the direction of flow is specified).
% A zero entry means no channel.  If both r(i,j) and r(j,i) are non-zero,
% this means that there are two separate uni-directional channels: 
% from i to j and from j to i.

% The loop of channels. 
% Lake 1 feeds into Lake 2, which feeds into Lake 3, etc...
r = diag(ones(1,n-1),-1);
r(1,n) = 1;
r = 1e-2 * r;

R = sum(r);

%Build the ODE matrix  
%(note: there are more efficient ways to do this, but this one is simple & readable)
A = r;
for i=1:n
    A(i,i) = - R(i);
    A(i,:) = A(i,:) / V(i);
end
A

t_star = 1000;  %after how many days will we check the concentrations?


%The ODE system is c'(t) = A c(t)

cc=[];  %the history of concentrations
for t=0:t_star
    B = expm(t*A);
    c = B * c0;
    %Note: for every i, the i-th column of B can be interpreted as c(t) 
    %corresponding to a very special initial condition: 
    %concentration 1 in the i-th lake & concentration 0 everywhere else.
    %In fact, c=B*c0 is the "linear superposition principle" at work!
    
    cc= [cc c];
end

%	close all;
%	plot(cc');  
%	legend('Lake 1', 'Lake 2', 'Lake 3', 'Lake 4', 'Lake 5', 'Lake 6');
%	xlabel('t');
%	ylabel('c');
%	pause

cc
csvwrite('data/six-lakes-no-purification.csv',[(0:t_star)' cc']);

A
A(1,1) = -0.015
cc=[];  %the history of concentrations
for t=0:t_star
    B = expm(t*A);
    c = B * c0;
    %Note: for every i, the i-th column of B can be interpreted as c(t) 
    %corresponding to a very special initial condition: 
    %concentration 1 in the i-th lake & concentration 0 everywhere else.
    %In fact, c=B*c0 is the "linear superposition principle" at work!
    
    cc= [cc c];
end

csvwrite('data/six-lakes-purification.csv', [(0:t_star)' cc']);

global R;
R = A;

pkg load odepkg;
function result = f(t, x)
	global R;
	result = R * x;
end

function [ value, isterminal, direction ] = event(t, x)
	value = max(x) - 0.2
	direction = 0;
	isterminal = 1;
end

opts = odeset('Events', @event);

[T, X] = ode45(@f, [0, 2000], c0, opts);
T(end)
