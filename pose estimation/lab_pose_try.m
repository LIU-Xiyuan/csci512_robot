close all
I = imread('lab_rec1.jpg');
I = rgb2gray(I);
imshow(I, [])
P_M = [ 0       0       10.2    0      0       10.2;
        19.5    8.9     0       19.5   8.9     0;
        14.6    14.6    14.8    7.6    7.6     7.6;
        1       1       1       1      1       1];

% Define camera parameters
f = 21879; % focal length in pixels
           % iPhone 7 focal length 28mm, image width 4032 pixels
center=size(I)/2+.5;
cx = center(1);
cy = center(2);
K = [ f 0 cx; 0 f cy; 0 0 1 ]; % intrinsic parameter matrix
y0 = [ 868; 1652; % 1
       1277; 1677; % 2
       2251; 1691; % 3
       868; 2091; % 4
       1268; 2182; % 5
       2231; 2177 ]; % 6

% Make an initial guess of the pose [ax ay az tx ty tz]
x = [0; 0; 0; 0; 0; 0];
% Get predicted image points by substituting in the current pose
y = fProject(x, P_M, K);

% for i=1:2:length(y)
%  rectangle('Position', [y(i)-8 y(i+1)-8 16 16], 'FaceColor', 'r');
% end

for i=1:10
 fprintf('\nIteration %d\nCurrent pose:\n', i);
 disp(x);

 % Get predicted image points
 y = fProject(x, P_M, K);
 imshow(I, [])
 for i=1:2:length(y)
 rectangle('Position', [y(i)-16 y(i+1)-16 32 32], ...
 'FaceColor', 'r');
 end
 pause(1);

 % Estimate Jacobian
 e = 0.00001; % a tiny number
 J(:,1) = ( fProject(x+[e;0;0;0;0;0],P_M,K) - y )/e;
 J(:,2) = ( fProject(x+[0;e;0;0;0;0],P_M,K) - y )/e;
 J(:,3) = ( fProject(x+[0;0;e;0;0;0],P_M,K) - y )/e;
 J(:,4) = ( fProject(x+[0;0;0;e;0;0],P_M,K) - y )/e;
 J(:,5) = ( fProject(x+[0;0;0;0;e;0],P_M,K) - y )/e;
 J(:,6) = ( fProject(x+[0;0;0;0;0;e],P_M,K) - y )/e;
 % Error is observed image points - predicted image points
 dy = y0 - y;
 fprintf('Residual error: %f\n', norm(dy));
 % Ok, now we have a system of linear equations dy = J dx
 % Solve for dx using the pseudo inverse
 dx = pinv(J) * dy;
 % Stop if parameters are no longer changing
 if abs( norm(dx)/norm(x) ) < 1e-6
 break;
 end
 x = x + dx; % Update pose estimate
end

% Draw coordinate axes onto the image. Scale the length of the axes
% according to the size of the model, so that the axes are visible.
W = max(P_M,[],2) - min(P_M,[],2); % Size of model in X,Y,Z
W = norm(W); % Length of the diagonal of the bounding box
u0 = fProject(x, [0;0;0;1], K); % origin
uX = fProject(x, [W/5;0;0;1], K); % unit X vector
uY = fProject(x, [0;W/5;0;1], K); % unit Y vector
uZ = fProject(x, [0;0;W/5;1], K); % unit Z vector
line([u0(1) uX(1)], [u0(2) uX(2)], 'Color', 'r', 'LineWidth', 3);
line([u0(1) uY(1)], [u0(2) uY(2)], 'Color', 'g', 'LineWidth', 3);
line([u0(1) uZ(1)], [u0(2) uZ(2)], 'Color', 'b', 'LineWidth', 3);
% Also print the pose onto the image.
text(30,450,sprintf('ax=%.2f ay=%.2f az=%.2f tx=%.1f ty=%.1f tz=%.1f', ...
 x(1), x(2), x(3), x(4), x(5), x(6)), ...
 'BackgroundColor', 'w', 'FontSize', 15);
