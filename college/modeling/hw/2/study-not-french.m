pkg load optim


n_classes = 6;
n_major_classes = 3;

% minimum acceptible overall grade
min_grade = 3.0;

% minimum acceptible major grade
min_major_grade = 3.5;

% Total Number of workable hours in the week
H = 70;

% Goal: minimize study time
f = [1;1;1;1;1;1];

% Number of hours per week to finish problem set.
% On study weeks before prelims, this is the amount of studying
%		in hours to achieve a perfect score.
h_req_1 = 12.0;
h_req_2 = 6.0;  % major class
h_req_3 = 7.0;  % major class
h_req_4 = 5.0;  % major class
h_req_5 = 4.0;
h_req_6 = 1.0;
h_req = [h_req_1; h_req_2; h_req_3; h_req_4; h_req_5; h_req_6];

% Expected grade per class with no studying
b_1 = 1.0;
b_2 = 2.0;
b_3 = 2.0;
b_4 = 1.5;
b_5 = 2.5;
b_6 = 2.5;
b = [b_1; b_2; b_3; b_4; b_5; b_6];

% the grade in the class is given by:
% g = b + ( h ./ h_req ) * 4.0

% average grade is given by:
% sum(g) / n_classes = sum(b) / n_classes + sum( h ./ h_req ) * ( 4.0 / n_classes)
% 
% if average grade must be greater than min_grade,
% (4.0 ./ (h_req * n_classes))' * h < -sum(b) / n_classes + min_grade

% setup main grade
total_gpa_constraint_line = (4.0 - b) ./ (h_req * n_classes);
total_gpa_constraint_maximum = min_grade - sum(b) / n_classes;

% setup major grade.  Use same process but only refer to major classes
major_gpa_constraint_line = ([(4.0 - b(2))/h_req(2); (4.0 - b(3))/h_req(3); (4.0 - b(4))/h_req(4)] / n_major_classes);
major_gpa_constraint_maximum = min_major_grade - sum([b(2); b(3); b(4)]) / n_major_classes;

% in addition to already specified constraints,
%   constrain each hour number to be greater than 0
%   and less than than the number required to get a 4.0 (to keep grades below 4.0)

A = [ ones(1,6); -total_gpa_constraint_line'; 0, -major_gpa_constraint_line', 0, 0; -eye(6); eye(6)];
b_constraint = [ H; -total_gpa_constraint_maximum; -major_gpa_constraint_maximum; zeros(6,1) ; h_req]; 

h = linprog(f, A, b_constraint)

printf("Study Plan:\n");
printf("Class \t\t Hours per Week\n");
printf("-------------------------------\n");
printf("Quantum Field: \t\t %f\n", h(1));
printf("Math Modeling: \t\t %f\n", h(2));
printf("Topology: \t\t %f\n", h(3));
printf("Combinatorics: \t\t %f\n", h(4));
printf("Robot Arms: \t\t %f\n", h(5));
printf("French: \t\t %f\n", h(6));
printf("-------------------------------\n");
printf("Estimated GPA: %f\n", sum(b + ( h ./ h_req ) .* (4.0 - b))/6.0);
printf("Estimated Major GPA: %f\n", (b(2) + b(3) + b(4) + ( (4.0 - b(2)) * h(2) / h_req(2) + (4.0 - b(3)) * h(3) / h_req(3) + (4.0 - b(4)) * h(4) / h_req(4) ))/3.0);
