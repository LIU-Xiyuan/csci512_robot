clear all
close all
I = imread('D67.gif');
B = im2bw(I, graythresh(I)); % Threshold image
s=strel('disk',5,0);
B=~B;
figure, imshow(B);
I3=imerode(B,s);
figure, imshow(I3);
s=strel('disk',1,0);
I2=imdilate(I3,s);
figure, imshow(I2);
L = bwlabel(I2);
blobs = regionprops(L);
for i=1:length(blobs)
 % Draw a rectangle around each blob
 rectangle('Position', blobs(i).BoundingBox, 'EdgeColor', 'r');
 % Draw crosshair at center of each blob
end