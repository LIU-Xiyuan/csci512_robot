clear all
close all
I2 = imread('pavilionCenter.jpg');
[H,W] = size(I2);
I1 = imread('pavilionLeft.jpg');
I3 = imread('pavilionRight.jpg');
if ~exist('points12_pavilion.mat', 'file')
% Start the GUI to select corresponding points
[Pts1,Pts2] = cpselect(I1,I2, 'Wait', true);
save('points12_pavilion.mat', 'Pts1', 'Pts2');
else
load('points12_pavilion.mat');
end
% Compute transform, from corresponding control points
t12 = fitgeotrans(Pts1,Pts2,'projective');
if ~exist('points32_pavilion.mat', 'file')
% Start the GUI to select corresponding points
[Pts3,Pts2] = cpselect(I3,I2, 'Wait', true);
save('points32_pavilion.mat', 'Pts3', 'Pts2');
else
load('points32_pavilion.mat');
end
% Compute transform, from corresponding control points
t32 = fitgeotrans(Pts3,Pts2,'projective');
ref2Dinput = imref2d( ...
[H, 3*W], ... % Size of output image (rows, cols)
[-W, 2*W], ... % xWorldLimits
[1, H]); % yWorldLimits
I1Warp = imwarp(I1,t12, 'OutputView', ref2Dinput );
I3Warp = imwarp(I3,t32, 'OutputView', ref2Dinput );
Icombined = [I1Warp(:,1:W) I2 I3Warp(:,2*W+1:3*W)];
figure, imshow(Icombined, []);