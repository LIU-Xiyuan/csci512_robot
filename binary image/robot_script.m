clear all
close all
I = imread('robot.jpg');
B = im2bw(I, graythresh(I)); % Threshold image
s=strel('disk',5,0);
B=~B;
I2=imdilate(B,s);
I3=imerode(I2,s);
I3=~I3;

s=strel('disk',8,0);
I4=imerode(I3,s);
I5=imdilate(I4,s);
imshow(I5);

% I3 = double(I3); % Convert image to double
% figure, imshow(I3);
% I4 = imfilter(I3, fspecial('average',[500,500]));
% figure, imshow(I4);
% Idiff = I3 - I4;
% figure, imshow(Idiff);
% % Segment white blobs
% W = Idiff>0;
% figure, imshow(W, []);

L = logical(I5); % Do connected component labeling
blobs = regionprops(L); % Get region properties
imshow(I);
for i=1:length(blobs)
 % Draw a rectangle around each blob
 c = blobs(i).Centroid; % Get centroid of blob
 pixels_c = impixel(I3,c(1),c(2));
 pixels_c = pixels_c(1)+pixels_c(2)+pixels_c(3);
 pixels_1 = impixel(I3,blobs(i).BoundingBox(1)+blobs(i).BoundingBox(3)/4,...
                    blobs(i).BoundingBox(2)+blobs(i).BoundingBox(4)/4);
 pixels_1 = pixels_1(1)+pixels_1(2)+pixels_1(3);
 pixels_2 = impixel(I3,blobs(i).BoundingBox(1)+blobs(i).BoundingBox(3)/4,...
                    blobs(i).BoundingBox(2)+blobs(i).BoundingBox(4)*3/4);
 pixels_2 = pixels_2(1)+pixels_2(2)+pixels_2(3);
 w=blobs(i).BoundingBox(3);
 h=blobs(i).BoundingBox(4);
 if((pixels_c==0)&&(pixels_1==3)&&(pixels_2==3)&&(w<110)&&(h<110))
     
     rectangle('Position', blobs(i).BoundingBox, 'EdgeColor', 'r');
     % Draw crosshair at center of each blob

     line([c(1)-5 c(1)+5], [c(2) c(2)], 'Color', 'g');
     line([c(1) c(1)], [c(2)-5 c(2)+5], 'Color', 'g');
 end
end