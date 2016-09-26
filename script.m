clear all
close all
I = imread('robot.jpg');
B = im2bw(I, graythresh(I)); % Threshold image
s=strel('disk',5,0);
B=~B;
I2=imdilate(B,s);
I3=imerode(I2,s);
I3=~I3;
L = bwlabel(I3); % Do connected component labeling
blobs = regionprops(L); % Get region properties
for i=1:length(blobs)
 % Draw a rectangle around each blob
 rectangle('Position', blobs(i).BoundingBox, 'EdgeColor', 'r');
 % Draw crosshair at center of each blob
 c = blobs(i).Centroid; % Get centroid of blob
 line([c(1)-5 c(1)+5], [c(2) c(2)], 'Color', 'g');
 line([c(1) c(1)], [c(2)-5 c(2)+5], 'Color', 'g');
end