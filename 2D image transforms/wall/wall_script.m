clear all
close all
Iin1 = imread('wall.jpg');
imshow(Iin1,[]), impixelinfo;
% Location of control points in (x,y) input image coords (pixels)
% These are the corners of a rectangle that is 8 bricks high by 13 bricks
% wide. Each brick is about 23 cm.
Pimg1 = [
1699, 982;
3217, 1186;
1721, 1917;
3259, 1802;
];
% Mark control points on input image, to verify that we have correct locations.
for i=1:size(Pimg1, 1)
rectangle('Position', [Pimg1(i,1)-10 Pimg1(i,2)-10 20 20], 'FaceColor', 'r');
end
% Define location of control points in the world. The control points are
% the corners of a rectangle that is 8 bricks high by 13 bricks wide. Each
% brick is about 23 cm. We'll define the upper left control point to be at
% (X,Y)=(0,0), with the +X axis to the right and the +Y axis down.
Pworld1 = [
0, 0; % Units in cm
600, 0;
0, 184;
600, 184;
];
% Compute transform, from corresponding control points
Tform1 = fitgeotrans(Pimg1,Pworld1,'projective');
% Transform input image to output image
Iout1 = imwarp(Iin1,Tform1);
figure, imshow(Iout1,[]);