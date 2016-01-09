% "Boats & life-vests" example from Chapter 1.1 of 
% UW-developed "Discrete Mathematical Modeling" lecture notes;
% see the link on our course website.
%
% This "quick & dirty" Matlab script was developed by A. Vladimirsky
% for illustrative/Matlab-intro purposes only.
% It was extensively modified by Christopher Silvia as a homework exercise.

% Establish the parameters

CV = 1;     % (capacity of each vest)
CB = 20;    % (capacity of each boat)
C = 1000;   % (total capacity needed)
VV = 0.05;  % (volume of each vest)
VB = 2.1;   % (volume of each boat)
V = 85.0;     % (total volume available)

% Reassign variables if the "vest" is larger than the "boat"
%   to comply with spec.
if CV > CB
  printf("Supplied Boat is smaller than Supplied Vdest, switching\n");
  temp = VB
  VB = VV
  VV = temp
  temp = CB
  CB = CV
  CV = temp
end
 
% Now the boat is the one with the larger capacity.

symmetric_boats = 0;  % should the number of boats be always even?
                      % (1 or 0 for "true" or "false")
% the skip_number denotes with what spacing to use for the integer search
if (symmetric_boats)
  skip_number = 2;
else
  skip_number = 1;
end

% We require that NV CV + NB CB >= C, i.e. that there be enough total capacity
% If we imagine a plane, with the two axes being NB and CB, 
%   this region is the region above a line stretching from C/CB to C/CV.
% Similarly, the region which requires that the volume not exceed the total
%   is the region underneath a line stretching from V/VB to V/VV.
% We want to choose the point within this region which maximizes the number
%   of boats in the combination.
% This will be the point with the greatest magnitude in the NB direction which
%   lies in the intersection of the regions with requisite capacity and
%   magnitude.
% Suppose the lines do not intersect.
% Then, one or other of the lines is on top.
% Since the admissible region for capacity lies above its line, which is 
%   another way of saying that the capacity must be no less than enough for
%   everyone, if the capacity line is entirely above the volume line
%   then there isn't knough space for everybody, and no arrangement of vests
%   and boats can save everybody and stay within the designated volume.
% We know that the capacity line lies entirely above the volume line
%   if (C/CB) > (V/VB) and (C/CV > V/VV).

if ((C/CB > V/VB) && (C/CV > V/VV))
    error("There is too little volume for the designated capacity")
end

% Let us continue to suppose that the lines bordering the admissible regions
%   of capacity and volume do not intersect, but let us consider the 
%   case in which there is a common region: The line bordering the volume
%   constraint lies completely above the line bordering the capacity
%   constraint in the (number of vests)-(number of boats) plane.
% Then, any point within the region solves the problem.  

if ((C/CB <= V/VB) && (C/CV <= V/VV))
    lower_boat_bound = 0;
    upper_boat_bound = floor(V/VB);
else

% We can consider the case where the lines intersect.
% In this case, we will determine bounds on the number of vests in the region.
% First let's determine the point where the lines intersect.

  A = [CV  CB;  VV VB];   % the matrix encoding the coefficients of the linear system
  b= [C; V];              % the "right hand side"

  
  % x(1) is the number of vests
  % x(2) is the number of boats

  x = A\b     % solve the system  (a missing semi-colon ensures that the answer is printed)

  % The admissible region is above the capacity line and below the volume line.
  % So if the intersection of the volume line with the boats axis is further out
  %   than the intersection of the capacity line with the boats axis,
  %   the admissible region touches the boats line.
  if ( (V/VB) >= (C/CB))
    % The admissible region stretches from boats = x(2) to V/VB in this case.
    % I begin the integer search at the top of the region (most boats possible)
    %   and proceed downwards
    lower_boat_bound = ceil(x(2));
    upper_boat_bound = floor(V/VB);
  else
    % The admissible region stretches from boats = 0 to boats = x(2)
    % I begin the integer search at the top of the region (most boats possible)
    %    and proceed downwards.
    lower_boat_bound = 0;
    upper_boat_bound = floor(x(2));
  end
end

% If the boats need to be symmetrical, make sure that the upper boats bound
%   is an even number.
if (symmetric_boats && (mod(upper_boat_bound,2) == 1))
  upper_boat_bound = upper_boat_bound - 1;
end

% Since we prefer boats to vests, we will choose the lowest integer point
%   still within the admissible region.
% It is possible that there are no integer points within the admissible region.
% We will first try points which have no vests, and see if we can find
%   an integer solution.
% If so, we will search points with one vest, and so on.
% If we run until we leave the admissible region, then we will say that there
%   are no admissible integer points.


found_solution = false;
for number_of_boats = upper_boat_bound:(-skip_number):lower_boat_bound
  % for the boats/vests combo to have enough capacity, vests must be greater
  %   than lowest_fractional_vests
  lowest_fractional_vests = C/CV - (CB/CV) * number_of_boats;

  % there must be fewer vests than the vest_volume_bound
  vest_volume_bound = V/VV - (VB/VV) * number_of_boats;

  % the smallest integer number of vests that works
  number_of_vests = ceil(lowest_fractional_vests);

  % if we are at an admissible point within the region, end the loop.
  if (number_of_vests <= vest_volume_bound && number_of_vests >= 0)
    found_solution = true;
    break;
  end
end
if !(found_solution)
  error("An admissible region exists but no integer solutions could be found.");
end
 
%print the answer
printf("Total Capacity: %d\n", number_of_vests*CV + number_of_boats*CB);
printf("Total Volume: %d\n", number_of_vests*VV + number_of_boats*VB);
number_of_vests
number_of_boats
