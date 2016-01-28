% The chemical dissolving in interconnected "lakes" problem.
%
% Our basic assumption is that the volume of each "lake" 
% stays constant.  Can you re-write the system of ODEs to
% handle the more general case?


%Here we repeat the same problem, but using Matlab's built-in ODE solvers.
%This allows us to handle many time-dependent effects, for which we don't
%have solutions an analytic solution.
%E.g., the flow rate between the lakes which oscillates as a function of t.

pkg load odepkg
pkg load optim
global A

%initial concentrations of chemicals in each lake
c0 = [1;0;1;0;0;0];
%c0 = [3;0;0;0;1;0];
%c0 = [2;0;0;0;1;0];


n = length(c0); %the number of lakes

% The volumes of lakes in km^3
V = (1:n);

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

t_star = 300;  %after how many days will we check the concentrations?


%specify some accuracy requirements for the ode solvers
odeopt = odeset('AbsTol', 1e-6, 'RelTol', 1e-12);

function cdot = concentration_ode(t,c)
	global A
	
	%use any amplitude in (0,1) to see time-dependent effects
	%amplitude=0;
	amplitude=1;
	cdot = (2+amplitude*sin(2*pi*t/100)) * A*c;
end

[t,cc]=ode45(@concentration_ode, [0:t_star], c0, odeopt);

%let's experimentally test the linear superposition principle when 
%coefficients are time-dependent
cc_alternative=zeros(size(cc));
exp_matrix = zeros(size(c0),size(c0));
for i=1:n
    %prepare the special initial conditions
    e = zeros(n,1);
    e(i) = 1;
    %find the corresponding solution
    [t,w]=ode45(@concentration_ode,[0:t_star], e, odeopt);
    %note that this w is what we called w^i in the lecture

    cc_alternative = cc_alternative + c0(i)*w;
	exp_matrix
	w(end,:)
	exp_matrix(:, i) = w(end,:)
end

f = V'
Alinprog = [exp_matrix(1:5,:); -exp_matrix(1:5,:); -eye(6)]
b = [0.4*ones(5,1); -0.3*ones(5,1); zeros(6,1) ]
Aeq = [exp_matrix(6,:)]
beq = [0.4]

initial_conditions = linprog(f, Alinprog, b, Aeq, beq)
mass = initial_conditions .* V'
final_conditions = exp_matrix * initial_conditions

[t,cc] = ode45(@concentration_ode, [0:t_star], initial_conditions, odeopt);
csvwrite('data/part-3.csv',[(0:t_star)' cc]);

[t,cc]=ode45(@concentration_ode, [0:2000], initial_conditions, odeopt);
% close all;
%	plot(t,cc);
%	legend('Lake 1', 'Lake 2', 'Lake 3', 'Lake 4', 'Lake 5', 'Lake 6');
%	xlabel('t');
%	ylabel('c');

csvwrite('data/part-3-extended.csv',[(0:2000)' cc]);

%	pause
