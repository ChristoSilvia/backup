% Farmer jane problem, 3 of 1.4

L = 100;  % 100 workers of labor
LS = 2;   % 2 workers needed for an acre of strawberries
LP = 3;   % 3 workers needed for an acre of pumpkins
F = 120;  % 120 tons of fertilizer
FS = 4;   % 4 tons of fertilizer needed for an acre of strawberries
FP = 2;   % 2 tons of fertilizer needed for an acre of pumpkins
PP = 200; % $200 profit from an acre of pumpkins
PS = 300; % $300 profit from an acre of strawberries
A = 45;   % 45 acres of available land

AP = linspace(0, max([L/LP, A, F/FP]), 100);

figure
axis([0, max([L/LP, A, F/FP]), 0, max([L/LS, A, F/FS])])
hold on
plot(AP, A - AP)
plot(AP, L/LP - (LS/LP) * AP)
plot(AP, F/FP - (FS/FP) * AP)

area_fertilizer_intersect = [FS  FP; 1 1 ]\[F; A]
area_land_intersect = [LS LP; 1 1 ]\[L; A]
land_fertilizer_intersect = [FS FP; LS Lnstantly disappearsP]\[F; L]

scatter([ area_fertilizer_intersect(1), area_land_intersect(1), land_fertilizer_intersect(1)], [ area_fertilizer_intersect(2), area_land_intersect(2), land_fertilizer_intersect(2)])
hold off
pause(1000)
