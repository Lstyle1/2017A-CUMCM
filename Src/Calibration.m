% -------------------------------------------------------------------------
% Calibrate CT system
% Author: Lyn
% Contact: lstylefu1@gmail.com
% Date: 2018.4.10
%--------------------------------------------------------------------------
%% Calibration of distance between units
temp_absorb = xlsread('data',2);
temp_mask = (temp_absorb > 0); % All elements are 1 or 0
width = sum(temp_mask); % Vector of shape (1xn)
% Values and indices of widest and narrowest positions
wmax = max(width);
wmin = min(width);
imaxs = find(width == wmax);
imins = find(width == wmin);
imax = imaxs(ceil(end/2)); % Find middle index among all max values
imin = imins(ceil(end/2)); % Find middle index among all min values
subplot(1,2,1);
imagesc(temp_absorb);
hold on;
% Plot max position with red line, min position with green line.
plot([imax, imax], [0, 512], 'r', [imin, imin], [0, 512], 'g');
% Calibration of distance between units
unit_d = 80 / (wmax - 1);
fprintf('The distance between units is: %.5f.\n', unit_d);
%% Calibration of rotation center
% iy and ix correspond to indices of center deviation
[~, iy] = max(temp_absorb(1: 512, imax: imax));
[~, ix] = max(temp_absorb(1: 512, imin: imin));
y_delta = unit_d * (256 - iy);
x_delta = unit_d * (256 - ix);
fprintf('The position of rotation center is: (%.5f, %.5f).\n', x_delta, y_delta);
% Visualize the two points
plot([imax, imin], [iy, ix], 'c*', 'Color','w');
%% Calibration of 180 directions
% Find middle points of oval
middle_oval = zeros(1, 180); % To store middle points of oval
middle_circle = zeros(1, 180); % To store middle points of circle
edge_oval = edge(temp_absorb, 'Canny', 0.3); % This threshold happens to describe the oval 
for i = 1: 180
    [~, upperi] = max(edge_oval(:,i)); % Find edge uppermost of the oval
    [~, downi] = max(flip(edge_oval(:,i))); % Find edge downmost of the oval
    middle_oval(i) = ceil((upperi + 512 - downi) / 2);
end
% Show the middle line of the oval
subplot(1,2,2);
imagesc(temp_absorb); hold on;
plot([1:180], middle_oval,'Color','black'); hold on;

% Find middle points of the circle
middle_circle = zeros(1, 180); % To store middle points of circle
% This formula can get the incomplete circle trace
edge_circle = edge(temp_absorb,'Canny',0.2)-edge(temp_absorb,'Canny',0.5);
upperi_last = 0; % Intialize last value
for j = 1: 180
    num = 0; % Initialize the value
    [num, upperi] = max(edge_circle(:,j));
    if (num == 0 && j ~= 1) | upperi - upperi_last > 5 % There is no point on edge
        middle_circle(j) = middle_circle(j-1) - 2;
    else       
        middle_circle(j) = upperi + 1 + ceil(4 / unit_d); % 4 is the radius of the circle
    end
    upperi_last = upperi;
end
% Show the middle line of the circle
plot([1:180], middle_circle, 'Color', 'black');

% Compute the distance between two rays through centers of circle and oval 
theta_delta = zeros(1, 180);
theta_last = 0;
for k = 1: 180
    ray_d = abs(middle_circle(k) - middle_oval(k)) * unit_d;
    theta = asin(ray_d / 45);
    theta_delta(k) = abs(theta - theta_last);
    theta_last = theta;
end
theta_delta_angle = theta_delta * 180 / pi; % Specify every interval in radians
fprintf('Mean angle of rotation is: %.5f. \n',mean(theta_delta_angle(10:170))); % Compare mean interval in valid range with 1 degree
fprintf('Hence we assume each rotation is 1 degree.\n');
