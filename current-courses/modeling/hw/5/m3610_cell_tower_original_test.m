
%This solves the original problem as stated in the Math 1220 Final.
%For the specified x(t), y(t) & Q(x,y), it is easy to get the analytic
%answer, but the following code will also work in the general case, when
%the antiderivatives cannot be written out explicitly.
function m3610_cell_tower_original_test

startTime = 0;
endTime = pi;
average_q = quad(@quality_at_time_t, startTime, endTime) / (endTime-startTime)

distance =  quad(@speed, startTime, endTime)

const_speed_of_travel = distance / (endTime-startTime)




function x_coord = x(t)

x_coord = -1 - cos(t);

function y_coord = y(t)

y_coord = -1 + cos(t);


function xp = xprime(t)
xp = sin(t);

function yp = yprime(t)
yp = -sin(t);


function s = speed(t)

s = sqrt( (xprime(t)).^2 + (yprime(t)).^2 );


%call quality for each location
function q = quality(x,y)
global cell_tower

cell_tower = [0; 0];

best_q =  20;
max_d = 2;
decay_rate_per_d2 = 5;

d = sqrt( (x-cell_tower(1)).^2 + (y-cell_tower(2)).^2 );

q = best_q - decay_rate_per_d2 * d.^2;

%constrain based on d
q = q.*(d<2);


function q = quality_at_time_t(t)
q = quality(x(t),y(t));