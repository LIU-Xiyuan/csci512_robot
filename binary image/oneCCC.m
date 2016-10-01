clear all
close all
movieObj = VideoReader('oneCCC.wmv'); % open file
images = read(movieObj);
get(movieObj) % display all information about movie
nFrames = movieObj.NumberOfFrames;
% Read every other frame from this movie.
%for iFrame=1:2:nFrames
for i=1:nFrames
 I = images(:,:,:,i);
 %I = read(movieObj,iFrame); % get one RGB image
 fprintf('Frame %d\n', i);
 B = im2bw(I, graythresh(I)); % Threshold image
 s=strel('disk',1,0);
 B=~B;
 I2=imdilate(B,s);
 I3=imerode(I2,s);
 %I3=~I3;
 imshow(I3,[]); % Display image

 % Pause a little so we can see the image. If no argument is given, it
 % waits until a key is pressed.
 %pause(0.01);
end