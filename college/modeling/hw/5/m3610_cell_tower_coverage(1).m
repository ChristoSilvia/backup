function m3610_cell_tower_coverage
global cell_tower

close all;
xx=0:.01:1; yy=xx;

[x,y] = meshgrid(xx,yy);
z = density(x,y);
contourf(xx,yy,z);
axis image;
colorbar;

%total population
population = dblquad(@density,0,1,0,1)

cell_tower = [0.5,0.5];
%cell_tower = [0.3,0.3];
%cell_tower = [0.8,0.8];
average_quality = dblquad(@weighted_quality,0,1,0,1) / population

%Due to the symmetry, it is clear that the optimal location should be on
%the main diagonal.  But can you find the exact point which maximizes the
%average call quality for stationary callers?

%What if you also have to provide the minimum level of quality 
%(e.g., Q > 17.4 throughout the map) -- how would you place the cell tower
%to maximize the _average_ quality subject to this constraint?
%
%Alternatively: 
%What if you have 2 different caller-density functions & you are not sure
%which one will be in effect at a given time (e.g., workdays vs weekends or
%evenings?).  What does it mean for the location to be "optimal"?
%
%Try experimenting with this code to handle the above generalizations.



function d = density(x,y)

center1 =[0.3; 0.3];
a1 = 3;
b1 = 2;
d1 = sqrt( (x-center1(1)).^2 + (y-center1(2)).^2 );

center2 =[0.8; 0.8];
a2 = 2;
b2 = 20;
d2 = sqrt( (x-center2(1)).^2 + (y-center2(2)).^2 );

d = a1*exp(-b1*d1.^2) + a2*exp(-b2*d2.^2);

%constrain to [0,1]x[0,1]
d = d.*(abs(x-0.5)<=0.5).*(abs(y-0.5)<=0.5);

%call quality for each location
function q = quality(x,y)
global cell_tower

best_q =  20;
max_d = 2;
decay_rate_per_d2 = 5;

d = sqrt( (x-cell_tower(1)).^2 + (y-cell_tower(2)).^2 );

q = best_q - decay_rate_per_d2 * d.^2;

%constrain to [0,1]x[0,1]
q = q.* (abs(x-0.5)<=0.5).*(abs(y-0.5)<=0.5);
%constrain based on d
q = q.* (d<2);


function wq = weighted_quality(x,y)

wq = quality(x,y) .* density(x,y);