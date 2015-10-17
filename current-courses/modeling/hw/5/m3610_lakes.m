% The chemical dissolving in interconnected "lakes" problem.
% Our basic assumption is that the volume of each "lake" 
% stays constant.  Can you re-write the system of ODEs for the more general
% case?

%This script deals with 3 reservoirs only 
%-- see the other 2 files for the general case.

n = 3; %the number of lakes

% The volumes of lakes in km^3
V = ones(1,n);

% The mutal flow rates matrix
% r(i,j) = # of (km^3) of water passing from lake j to lake i per day.
%
% Note: all entries are non-negative (the direction of flow is specified).
% A zero entry means no channel.  If both r(i,j) and r(j,i) are non-zero,
% this means that there are two separate uni-directional channels: 
% from i to j and from j to i.


% The fully connected equally weighted graph of channels.
r = 1e-2 * [
    0   1   1
    1   0   1
    1   1   0];

% The loop of channels.
% Lake1 feeds into Lake2, which feeds into Lake3, which feeds into Lake1.
% 
% r = 1e-2 * [
%     0   0   1
%     1   0   0
%     0   1   0];

R = sum(r);

%Build the ODE matrix  
%(note: there are more efficient ways to do this, but this one is simple & readable)
A = r;
for i=1:n
    A(i,i) = - R(i);
    A(i,:) = A(i,:) / V(i);
end

t_star = 400;  %after how many days will we check the concentrations?

c0 = [1;0;0];


%The ODE system is c'(t) = A c(t)

cc=[];  %the history of concentrations
for t=0:t_star
    B = expm(t*A);
    c = B * c0;
    cc= [cc c];
end

close all;
plot(cc');  
legend('Lake 1', 'Lake 2', 'Lake 3');
xlabel('t');
ylabel('c');
