clear all
close all

I2 = imread('m.jpg');
%I2 = rgb2gray(I2);
m_red = I2(:,:,1); % Red channel
m_green = I2(:,:,2); % Green channel
m_blue = I2(:,:,3); % Blue channel
m_a = zeros(size(I2, 1), size(I2, 2));
m_just_red = cat(3, m_red, m_a, m_a);
m_just_green = cat(3, m_a, m_green, m_a);
m_just_blue = cat(3, m_a, m_a, m_blue);

[H,W] = size(m_just_red);

I1 = imread('l.jpg');
%I1 = rgb2gray(I1);
l_red = I1(:,:,1); % Red channel
l_green = I1(:,:,2); % Green channel
l_blue = I1(:,:,3); % Blue channel
l_a = zeros(size(I1, 1), size(I1, 2));
l_just_red = cat(3, l_red, l_a, l_a);
l_just_green = cat(3, l_a, l_green, l_a);
l_just_blue = cat(3, l_a, l_a, l_blue);

I3 = imread('r.jpg');
%I3 = rgb2gray(I3);
r_red = I3(:,:,1); % Red channel
r_green = I3(:,:,2); % Green channel
r_blue = I3(:,:,3); % Blue channel
r_a = zeros(size(I3, 1), size(I3, 2));
r_just_red = cat(3, r_red, r_a, r_a);
r_just_green = cat(3, r_a, r_green, r_a);
r_just_blue = cat(3, r_a, r_a, r_blue);

if ~exist('l_m_r.mat', 'file')
% Start the GUI to select corresponding points
[Pts1,Pts2] = cpselect(I1,I2, 'Wait', true);
save('l_m_r.mat', 'Pts1', 'Pts2');
else
load('l_m_r.mat');
end
% Compute transform, from corresponding control points
t12 = fitgeotrans(Pts1,Pts2,'projective');
if ~exist('r_m_r.mat', 'file')
% Start the GUI to select corresponding points
[Pts3,Pts2] = cpselect(I3,I2, 'Wait', true);
save('r_m_r.mat', 'Pts3', 'Pts2');
else
load('r_m_r.mat');
end
% Compute transform, from corresponding control points
t32 = fitgeotrans(Pts3,Pts2,'projective');
ref2Dinput = imref2d( ...
[H, 3*W], ... % Size of output image (rows, cols)
[-W, 2*W], ... % xWorldLimits
[1, H]); % yWorldLimits
%I1Warp = imwarp(I1,t12, 'OutputView', ref2Dinput );
I1Warp = imwarp(l_just_red,t12, 'OutputView', ref2Dinput );

%I3Warp = imwarp(I3,t32, 'OutputView', ref2Dinput );
I3Warp = imwarp(r_just_red,t32, 'OutputView', ref2Dinput );

Icombined = [I1Warp(:,1:W) m_just_red I3Warp(:,2*W+1:3*W)];
figure, imshow(Icombined, []);