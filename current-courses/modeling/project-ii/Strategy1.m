% We can define this problem as a discrete grid of points to traverse. We 
% declare each grid point spaced by the distance traveled 

% No geographic point in the city should remain unobserved from the air for
% more than 15 minutes in a row.  

length = 4828;
width = 4828;
area = length*width;    % area of city

ts = 15*60/48;  % time step per change in i
t_visit = 15*60;

w = 304.8; % width of the observable range of quad-copters
w2 = w*w; % square approx of area observed by drone

v = 16;  % velocity of the drone m/s
area_covered = v*15*60*304.8;   % area covered by drone after 15 minutes
drones_needed1 = ceil(area/area_covered); % drones needed for Method I
num_cov_temp = area_covered/w2; % number of boxes needed in grid per drone
num_cov = ceil(num_cov_temp);   % rounded up

num_boxes_temp = area/w2;    % number of boxes needed in grid
s_num = ceil(sqrt(num_boxes_temp));  
num_boxes = s_num*s_num;    % approximate number to make even square

x = 1;
y = 1;
t = 0;

% Base case where we can assume the copter observes 1 block per time step
% (to scale)

% Initialize location array
location = zeros(s_num);

% Initialize time since visited array
visit = zeros(s_num);

for i=1:s_num
    for j=1:s_num
        visit(i,j) = t_visit;
    end
end

% Initialize offsets of drones
pos_2x = 6;
pos_2y = 0;
pos_3x = 10;
pos_3y = 0;
pos_4x = 0;
pos_4y = 8;
pos_5x = 6;
pos_5y = 8;
pos_6x = 10;
pos_6y = 8;

% Initialize position of drones
location(x,y) = 1;
location(x + pos_2x, y + pos_2y) = 1;
location(x + pos_3x, y + pos_3y) = 1;
location(x + pos_4x, y + pos_4y) = 1;
location(x + pos_5x, y + pos_5y) = 1;
location(x + pos_6x, y + pos_6y) = 1;

% Initialize movement array of each drone
d1x = [x];
d1y = [y];
d2x = [x + pos_2x];
d2y = [y + pos_2y];
d3x = [x + pos_3x];
d3y = [y + pos_3y];
d4x = [x + pos_4x];
d4y = [y + pos_4y];
d5x = [x + pos_5x];
d5y = [y + pos_5y];
d6x = [x + pos_6x];
d6y = [y + pos_6y];

%disp(location);

for j = 1:3
    for i = 1:48
        
        if (min(min(visit)) == 0)
            disp('Failure to observe');
        end
        
        % Add time step
        t = t + ts;
        
        % Update time since visited matrix
        visit = visit - ts;
        
        if (i <= 5)
        
            x = x + 1;
            
            location(x,y) = 1;
            location(x-1,y) = 0;
            visit(x,y) = t_visit;
        
            location(x + pos_2x, y + pos_2y) = 1;
            location(x + pos_2x - 1, y + pos_2y) = 0;
            visit(x + pos_2x, y + pos_2y) = t_visit;
                
            location(x + pos_3x, y + pos_3y) = 1;
            location(x + pos_3x - 1, y + pos_3y) = 0;
            visit(x + pos_3x, y + pos_3y) = t_visit;
            
            location(x + pos_4x, y + pos_4y) = 1;
            location(x + pos_4x - 1, y + pos_4y) = 0;
            visit(x + pos_4x, y + pos_4y) = t_visit;
        
            location(x + pos_5x, y + pos_5y) = 1;
            location(x + pos_5x - 1, y + pos_5y) = 0;
            visit(x + pos_5x, y + pos_5y) = t_visit;
        
            location(x + pos_6x, y + pos_6y) = 1;
            location(x + pos_6x - 1, y + pos_6y) = 0;
            visit(x + pos_6x, y + pos_6y) = t_visit;
        
            d1x = [d1x x];
            d1y = [d1y  y];
            d2x = [d2x  (x + pos_2x)];
            d2y = [d2y  (y + pos_2y)];
            d3x = [d3x  (x + pos_3x)];
            d3y = [d3y  (y + pos_3y)];
            d4x = [d4x  (x + pos_4x)];
            d4y = [d4y  (y + pos_4y)];
            d5x = [d5x  (x + pos_5x)];
            d5y = [d5y  (y + pos_5y)];
            d6x = [d6x  (x + pos_6x)];
            d6y = [d6y  (y + pos_6y)];

            %disp(location);
        end
    
        if (i >= 6 && i <=12)
        
            y = y + 1;
        
            location(x,y) = 1;
            location(x,y-1) = 0;
            visit(x,y) = t_visit;
        
            location(x + pos_2x, y + pos_2y) = 1;
            location(x + pos_2x, y + pos_2y - 1) = 0;
            visit(x + pos_2x, y + pos_2y) = t_visit;
        
            location(x + pos_3x, y + pos_3y) = 1;
            location(x + pos_3x, y + pos_3y-1) = 0;
            visit(x + pos_3x, y + pos_3y) = t_visit;
        
            location(x + pos_4x, y + pos_4y) = 1;
            location(x + pos_4x, y + pos_4y-1) = 0;
            visit(x + pos_4x, y + pos_4y) = t_visit;
        
            location(x + pos_5x, y + pos_5y) = 1;
            location(x + pos_5x, y + pos_5y - 1) = 0;
            visit(x + pos_5x, y + pos_5y) = t_visit;
        
            location(x + pos_6x, y + pos_6y) = 1;
            location(x + pos_6x, y + pos_6y-1) = 0;
            visit(x + pos_6x, y + pos_6y) = t_visit;
        
            d1x = [d1x x];
            d1y = [d1y  y];
            d2x = [d2x  (x + pos_2x)];
            d2y = [d2y  (y + pos_2y)];
            d3x = [d3x  (x + pos_3x)];
            d3y = [d3y  (y + pos_3y)];
            d4x = [d4x  (x + pos_4x)];
            d4y = [d4y  (y + pos_4y)];
            d5x = [d5x  (x + pos_5x)];
            d5y = [d5y  (y + pos_5y)];
            d6x = [d6x  (x + pos_6x)];
            d6y = [d6y  (y + pos_6y)];
            
            %disp(location);
        end
    
        if ((i == 13) || (i==20) || (i == 27) || (i==34) || (i == 41))
        
            x = x - 1;
        
            location(x,y) = 1;
            location(x+1,y) = 0;
            visit(x,y) = t_visit;
        
            location(x + pos_2x, y + pos_2y) = 1;
            location(x + pos_2x + 1, y + pos_2y) = 0;
            visit(x + pos_2x, y + pos_2y) = t_visit;
        
            location(x + pos_3x, y + pos_3y) = 1;
            location(x + pos_3x + 1, y + pos_3y) = 0;
            visit(x + pos_3x, y + pos_3y) = t_visit;
        
            location(x + pos_4x, y + pos_4y) = 1;
            location(x + pos_4x + 1, y + pos_4y) = 0;
            visit(x + pos_4x, y + pos_4y) = t_visit;
        
            location(x + pos_5x, y + pos_5y) = 1;
            location(x + pos_5x + 1, y + pos_5y) = 0;
            visit(x + pos_5x, y + pos_5y) = t_visit;
        
            location(x + pos_6x, y + pos_6y) = 1;
            location(x + pos_6x + 1, y + pos_6y) = 0;
            visit(x + pos_6x, y + pos_6y) = t_visit;
        
            d1x = [d1x x];
            d1y = [d1y  y];
            d2x = [d2x  (x + pos_2x)];
            d2y = [d2y  (y + pos_2y)];
            d3x = [d3x  (x + pos_3x)];
            d3y = [d3y  (y + pos_3y)];
            d4x = [d4x  (x + pos_4x)];
            d4y = [d4y  (y + pos_4y)];
            d5x = [d5x  (x + pos_5x)];
            d5y = [d5y  (y + pos_5y)];
            d6x = [d6x  (x + pos_6x)];
            d6y = [d6y  (y + pos_6y)];
            
            %disp(location);
        end
    
        if ((i >=14 && i <=19) || (i >= 28 && i <= 33) || (i>=42))
        
            y = y - 1;
        
            location(x,y) = 1;
            location(x,y+1) = 0;
            visit(x,y) = t_visit;
        
            location(x + pos_2x, y + pos_2y) = 1;
            location(x + pos_2x, y + pos_2y + 1) = 0;
            visit(x + pos_2x, y + pos_2y) = t_visit;
        
            location(x + pos_3x, y + pos_3y) = 1;
            location(x + pos_3x , y + pos_3y+ 1) = 0;
            visit(x + pos_3x, y + pos_3y) = t_visit;
        
            location(x + pos_4x, y + pos_4y) = 1;
            location(x + pos_4x, y + pos_4y + 1) = 0;
            visit(x + pos_4x, y + pos_4y) = t_visit;
        
            location(x + pos_5x, y + pos_5y) = 1;
            location(x + pos_5x, y + pos_5y + 1) = 0;
            visit(x + pos_5x, y + pos_5y) = t_visit;
        
            location(x + pos_6x, y + pos_6y) = 1;
            location(x + pos_6x, y + pos_6y + 1) = 0;
            visit(x + pos_6x, y + pos_6y) = t_visit;
        
            d1x = [d1x x];
            d1y = [d1y  y];
            d2x = [d2x  (x + pos_2x)];
            d2y = [d2y  (y + pos_2y)];
            d3x = [d3x  (x + pos_3x)];
            d3y = [d3y  (y + pos_3y)];
            d4x = [d4x  (x + pos_4x)];
            d4y = [d4y  (y + pos_4y)];
            d5x = [d5x  (x + pos_5x)];
            d5y = [d5y  (y + pos_5y)];
            d6x = [d6x  (x + pos_6x)];
            d6y = [d6y  (y + pos_6y)];
            
            %disp(location);
        end
    
        if ((i >=21 && i <=26) || (i >= 35 && i <= 40))
        
            y = y + 1;
        
            location(x,y) = 1;
            location(x,y-1) = 0;
            visit(x,y) = t_visit;
        
            location(x + pos_2x, y + pos_2y) = 1;
            location(x + pos_2x, y + pos_2y - 1) = 0;
            visit(x + pos_2x, y + pos_2y) = t_visit;
        
            location(x + pos_3x, y + pos_3y) = 1;
            location(x + pos_3x , y + pos_3y - 1) = 0;
            visit(x + pos_3x, y + pos_3y) = t_visit;
            
            location(x + pos_4x, y + pos_4y) = 1;
            location(x + pos_4x, y + pos_4y - 1) = 0;
            visit(x + pos_4x, y + pos_4y) = t_visit;
            
            location(x + pos_5x, y + pos_5y) = 1;
            location(x + pos_5x, y + pos_5y - 1) = 0;
            visit(x + pos_5x, y + pos_5y) = t_visit;
            
            location(x + pos_6x, y + pos_6y) = 1;
            location(x + pos_6x, y + pos_6y - 1) = 0;
            visit(x + pos_6x, y + pos_6y) = t_visit;
            
            d1x = [d1x x];
            d1y = [d1y  y];
            d2x = [d2x  (x + pos_2x)];
            d2y = [d2y  (y + pos_2y)];
            d3x = [d3x  (x + pos_3x)];
            d3y = [d3y  (y + pos_3y)];
            d4x = [d4x  (x + pos_4x)];
            d4y = [d4y  (y + pos_4y)];
            d5x = [d5x  (x + pos_5x)];
            d5y = [d5y  (y + pos_5y)];
            d6x = [d6x  (x + pos_6x)];
            d6y = [d6y  (y + pos_6y)];
            
            %disp(location);
        end
    end
end

% disp(location);
% disp(visit);

% Plots current location of drones
figure
hold on;
dd1 = plot(x,y);
dd2 = plot(x + pos_2x, x + pos_2y);
dd3 = plot(x + pos_3x, x + pos_3y);
dd4 = plot(x + pos_4x, x + pos_4y);
dd5 = plot(x + pos_5x, x + pos_5y);
dd6 = plot(x + pos_6x, x + pos_6y);
plot(d1x, d1y, 'b')
plot(d2x, d2y, 'b')
plot(d3x, d3y, 'b')
plot(d4x, d4y, 'b')
plot(d5x, d5y, 'b')
plot(d6x, d6y, 'b')
set(dd1,'Marker','square')
set(dd2,'Marker','square')
set(dd3,'Marker','square')
set(dd4,'Marker','square')
set(dd5,'Marker','square')
set(dd6,'Marker','square')
t
