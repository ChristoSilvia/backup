I = imread('mississippi-elevation-picture.jpg');

color_scale_x = 90;
color_125_height = 21;
color_0_height = 692;

n = abs(color_125_height - color_0_height) + 1;
height = linspace(0,125,n);
color_r = reshape(I(color_0_height:-1:color_125_height, color_scale_x, 1),1,n);
color_g = reshape(I(color_0_height:-1:color_125_height, color_scale_x, 2),1,n);
color_b = reshape(I(color_0_height:-1:color_125_height, color_scale_x, 3),1,n);

figure
hold on
plot(height, color_r, 'r')
plot(height, color_b, 'b')
plot(height, color_g, 'g')

legend('red','blue','green')
hold off

figure
A = I(:,:,3) .* (I(:,:,1) < 250) .* (I(:,:,2) < 250);
imshow(A);

pause
