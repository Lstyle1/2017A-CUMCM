%% Calibrate the reconstruction center
% Load calibration data
load('Calib.mat');

% Read template sinogram from excel
sinogram = xlsread('data',2);
sinogram_ex = [sinogram, flipud(sinogram)];
sinogram_ex = [zeros(100,360); sinogram_ex; zeros(100,360)]; % Expand the sinogram for visualization
subplot(2,3,1);
imagesc(sinogram);

% Compute the initial angle
angle = asin(142*unit_d / 45) * 180 / pi; % Use the data of the first column
img = iradon(sinogram_ex, [0:359] - angle + 90);
[w, h] = size(img);

% Translate along x-axis
wid = sum(img, 1);
[~, max_index_x] = max(wid); % Find the widest position of oval
len = size(img, 1);
img1 = [img(:,max_index_x - len/2:end), img(:,1:max_index_x - len/2 - 1)]; 
% Translate along y-axis
for max_index_y1 = 1:len
    if img(max_index_y1, max_index_x) > 0.1
        break
    end
end    
% imagesc(img);hold on;plot(max_index_x,max_index_y1,'c*');
for max_index_y2 = 1:len
    if img(len-max_index_y2, max_index_x) > 0.1
        break
    end
end  
% plot(max_index_x,len-max_index_y2,'c*');
middle_index_y = ceil((max_index_y1 + len-max_index_y2)/2);
img2 = [img1(middle_index_y - len/2:end,:);img1(1:middle_index_y - len/2 -1,:)];

% Compute coordinates of the rotation center
xc = x_delta;
yc = y_delta;

% Visualize the reconstruction and rotation center
[xb, yb] = meshgrid([-w/2, w/2]*unit_d, [-h/2, h/2]*unit_d);
subplot(2,3,4);
imagesc(xb(1,:), yb(:,1), img2);
hold on;
plot(xc,-yc,'or');

% Draw the rectangle boundary and specific points
rectangle('Position', [-50, -50, 100, 100],'EdgeColor','w');
p = xlsread('data.xls',4);
plot(p(:,1)-50,-(p(:,2)-50),'c*','Color','black');

% Compute specific absorption rates
absorb = [];
for j = 1:size(p,1)
    absorb(j) = img2(ceil(p(j,1)/unit_d),len-ceil(p(j,2)/unit_d));
    fprintf('Absorption rate at position(%.1f, %.1f) of sample1 are: %.5f.\n',p(j,1),p(j,2),absorb(j));
end
fprintf('\n Hence we times all obtained absorption rates by 2 for correction.\n\n');
fprintf('\n');
%% Reconstruction of sample2
% Read sinogram from excel
sinogram = xlsread('data',3);
sinogram_ex = [sinogram, flipud(sinogram)];
sinogram_ex = [zeros(100,360); sinogram_ex; zeros(100,360)]; % Expand the sinogram for visualization
subplot(2,3,2);
imagesc(sinogram);

img = iradon(sinogram_ex, [0:359] - angle + 90);
img1 = [img(:,max_index_x - len/2:end), img(:,1:max_index_x - len/2 - 1)]; 
img2 = [img1(middle_index_y - len/2:end,:);img1(1:middle_index_y - len/2 -1,:)];

% Save the reconstruction data
recon = imresize(img2, [256, 256]);
xlswrite('problem2.xls', recon);

% Compute coordinates of the rotation center
xc = x_delta;
yc = y_delta;

% Visualize the reconstruction and rotation center
[xb, yb] = meshgrid([-w/2, w/2]*unit_d, [-h/2, h/2]*unit_d);
subplot(2,3,5);
imagesc(xb(1,:), yb(:,1), img2);
hold on;
plot(xc,-yc,'or');

% Draw the rectangle boundary and specific points
rectangle('Position', [-50, -50, 100, 100],'EdgeColor','w');
p = xlsread('data.xls',4);
plot(p(:,1)-50,-(p(:,2)-50),'c*','Color','black');

% Compute specific absorption rates
absorb = [];
for j = 1:size(p,1)
    absorb(j) = img2(ceil(p(j,1)/unit_d),len-ceil(p(j,2)/unit_d));
    fprintf('Absorption rate at position(%.1f, %.1f) of sample1 are: %.5f.\n',p(j,1),p(j,2),2*absorb(j));
end
fprintf('\n');
%% Reconstruction of sample3
% Read sinogram from excel
sinogram = xlsread('data',5);
sinogram_ex = [sinogram, flipud(sinogram)];
sinogram_ex = [zeros(100,360); sinogram_ex; zeros(100,360)]; % Expand the sinogram for visualization
subplot(2,3,3);
imagesc(sinogram);

img = iradon(sinogram_ex, [0:359] - angle + 90);
img1 = [img(:,max_index_x - len/2:end), img(:,1:max_index_x - len/2 - 1)]; 
img2 = [img1(middle_index_y - len/2:end,:);img1(1:middle_index_y - len/2 -1,:)];

% Save the reconstruction data
recon = imresize(img2, [256, 256]);
xlswrite('problem3.xls', recon);

% Compute coordinates of the rotation center
xc = x_delta;
yc = y_delta;

% Visualize the reconstruction and rotation center
subplot(2,3,6);
imagesc([-60,60], [-60,60], img2); % Restrict the visualization boundary.
hold on;
plot(xc,-yc,'or');

% Draw the rectangle boundary and specific points
rectangle('Position', [-50, -50, 100, 100],'EdgeColor','w');
p = xlsread('data.xls',4);
plot(p(:,1)-50,-(p(:,2)-50),'c*','Color','black');

% Compute specific absorption rates
absorb = [];
for j = 1:size(p,1)
    absorb(j) = img2(ceil(p(j,1)/unit_d),len-ceil(p(j,2)/unit_d));
    fprintf('Absorption rate at position(%.1f, %.1f) of sample1 are: %.5f.\n',p(j,1),p(j,2),2*absorb(j));
end
fprintf('\n');