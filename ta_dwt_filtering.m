%% Start with clean slate
clear all; close all; clc; imtool close all;
set(0, 'DefaultFigureWindowStyle','docked');

%% Specify data file directory
fileFolder = fullfile(pwd, 'dicom_dir');
files = dir(fullfile(fileFolder, '*.dcm'));
fileNames = {files.name};

%% Examine file header (metadata, from DICOM stack)
info = dicominfo(fullfile(fileFolder, fileNames{1}));
voxel_size = [info.PixelSpacing; info.SliceThickness];
numImages = length(fileNames);

%% Read slice images; populate 3-D matrix
hWaitBar = waitbar(0, 'Reading DICOM files');

%The following line wasn't legible in the tutorial
ctscan = zeros(info.Rows, info.Columns, numImages); %, class(info.

for i=length(fileNames):-1:1
    fname = fullfile(fileFolder, fileNames{i});
    ctscan(:,:,i) = uint16(dicomread(fname));
    
    waitbar((length(fileNames)-i+1)/length(fileNames))
end
delete(hWaitBar)

%% Explore image data usign Image Viewer GUI tool

im = ctscan(:,:,30); % using the 30th ct scan here
max_level = double(max(im(:)));
imt = imtool(im, [0, max_level]);

%% Explore dataset as a montage
imtool close all

%% Extract features using DWT (Currently using only the first image)
%Splits image into 4 layers. Then continues to divide the LL layer.
[LL, LH, HL, HH] = dwt2(ctscan(:,:,1),'haar');
[LL2, LH2, HL2 ,HH2] = dwt2(LL, 'haar');
[LL3, LH3, HL3, HH3] = dwt2(LL2, 'haar');
%{
[LL4, LH4, HL4, HH4] = dwt2(LL3, 'haar');
[LL5, LH5, HL5, HH5] = dwt2(LL4, 'haar');
%} 

%% Filter dwt layers into entropy filtering
%layer 1
ll_post_filter = entropyfilt(LL);
lh_post_filter = entropyfilt(LH);
hl_post_filter = entropyfilt(HL);
hh_post_filter = entropyfilt(HH);
%layer 2
ll2_post_filter = entropyfilt(LL2);
lh2_post_filter = entropyfilt(LH2);
hl2_post_filter = entropyfilt(HL2);
hh2_post_filter = entropyfilt(HH2);
%layer 3
ll3_post_filter = entropyfilt(LL3);
lh3_post_filter = entropyfilt(LH3);
hl3_post_filter = entropyfilt(HL3);
hh3_post_filter = entropyfilt(HH3);

%% Create a Grey-Scale Matrix
%layer 1
%[glcm_ll,SI] = graycomatrix(ll_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_ll = graycomatrix(ll_post_filter,'Offset',[2 0])

%[glcm_lh,SI] = graycomatrix(lh_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_lh = graycomatrix(lh_post_filter,'Offset',[2 0])

%[glcm_hl,SI] = graycomatrix(hl_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_hl = graycomatrix(hl_post_filter,'Offset',[2 0])

%[glcm_hh,SI] = graycomatrix(hh_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_hh = graycomatrix(hh_post_filter,'Offset',[2 0])

%layer 2
glcm_ll2 = graycomatrix(ll2_post_filter,'Offset',[2 0])
glcm_lh2 = graycomatrix(lh2_post_filter,'Offset',[2 0])
glcm_hl2 = graycomatrix(hl2_post_filter,'Offset',[2 0])
glcm_hh2 = graycomatrix(hh2_post_filter,'Offset',[2 0])

%layer 3
glcm_ll3 = graycomatrix(ll3_post_filter,'Offset',[2 0])
glcm_lh3 = graycomatrix(lh3_post_filter,'Offset',[2 0])
glcm_hl3 = graycomatrix(hl3_post_filter,'Offset',[2 0])
glcm_hh3 = graycomatrix(hh3_post_filter,'Offset',[2 0])
%% array for post matrices filtering and placing it in a csv file

array_layer1 = [glcm_ll, glcm_lh, glcm_hl, glcm_hh]
array_layer2 = [glcm_ll2, glcm_lh2, glcm_hl2, glcm_hh2]
array_layer3 = [glcm_ll3, glcm_lh3, glcm_hl3, glcm_hh3]

csvwrite('post_dwt_ta_filter.csv', array_layer1)
csvwrite('post_dwt_ta_filter_layer2.csv', array_layer2)
csvwrite('post_dwt_ta_filter_layer3.csv', array_layer3)

%% Subplots for filtering images

figure('Name', 'Pre-Filtering Layer 1', 'NumberTitle', 'off');
subplot(2,2,1);imshow(LL, []);title('LL');
subplot(2,2,2);imshow(LH, []);title('LH');
subplot(2,2,3);imshow(HL, []);title('HL');
subplot(2,2,4);imshow(HH, []);title('HH');

figure('Name','DWT Entropy Filtering Layer 1','NumberTitle','off');
subplot(2,2,1);imshow(ll_post_filter, []);title('LL');
subplot(2,2,2);imshow(lh_post_filter, []);title('LH');
subplot(2,2,3);imshow(hl_post_filter, []);title('HL');
subplot(2,2,4);imshow(hh_post_filter, []);title('HH');

figure('Name','Pre-Filtering Layer 2','NumberTitle','off');
subplot(2,2,1);imshow(LL2, []);title('LL2');
subplot(2,2,2);imshow(LH2, []);title('LH2');
subplot(2,2,3);imshow(HL2, []);title('HL2');
subplot(2,2,4);imshow(HH2, []);title('HH2');

figure('Name','DWT Entropy Filtering Layer 2','NumberTitle','off');
subplot(2,2,1);imshow(ll2_post_filter, []);title('LL2');
subplot(2,2,2);imshow(lh2_post_filter, []);title('LH2');
subplot(2,2,3);imshow(hl2_post_filter, []);title('HL2');
subplot(2,2,4);imshow(hh2_post_filter, []);title('HH2');

figure('Name','Pre-Filtering Layer 3','NumberTitle','off');
subplot(2,2,1);imshow(LL3, []);title('LL3');
subplot(2,2,2);imshow(LH3, []);title('LH3');
subplot(2,2,3);imshow(HL3, []);title('HL3');
subplot(2,2,4);imshow(HH3, []);title('HH3');

figure('Name','DWT Entropy Filtering Layer 3','NumberTitle','off');
subplot(2,2,1);imshow(ll3_post_filter, []);title('LL3');
subplot(2,2,2);imshow(lh3_post_filter, []);title('LH3');
subplot(2,2,3);imshow(hl3_post_filter, []);title('HL3');
subplot(2,2,4);imshow(hh3_post_filter, []);title('HH3');

%% K-means clustering
I_ll = im2double(ll_post_filter);
I_lh = im2double(lh_post_filter);
I_hl = im2double(hl_post_filter);
I_hh = im2double(hh_post_filter);

c_ll = kmeans(I_ll(:), 25);
c_lh = kmeans(I_lh(:), 25);
c_hl = kmeans(I_hl(:), 25);
c_hh = kmeans(I_hh(:), 25);

I_ll2 = im2double(ll2_post_filter);
I_lh2 = im2double(lh2_post_filter);
I_hl2 = im2double(hl2_post_filter);
I_hh2 = im2double(hh2_post_filter);

c_ll2 = kmeans(I_ll2(:), 25);
c_lh2 = kmeans(I_lh2(:), 25);
c_hl2 = kmeans(I_hl2(:), 25);
c_hh2 = kmeans(I_hh2(:), 25);

I_ll3 = im2double(ll3_post_filter);
I_lh3 = im2double(lh3_post_filter);
I_hl3 = im2double(hl3_post_filter);
I_hh3 = im2double(hh3_post_filter);

c_ll3 = kmeans(I_ll3(:), 25);
c_lh3 = kmeans(I_lh3(:), 25);
c_hl3 = kmeans(I_hl3(:), 25);
c_hh3 = kmeans(I_hh3(:), 25);
%% Reshaping
p_ll = reshape(c_ll, size(I_ll));
p_lh = reshape(c_lh, size(I_lh));
p_hl = reshape(c_hl, size(I_hl));
p_hh = reshape(c_hh, size(I_hh));

p_ll2 = reshape(c_ll2, size(I_ll2));
p_lh2 = reshape(c_lh2, size(I_lh2));
p_hl2 = reshape(c_hl2, size(I_hl2));
p_hh2 = reshape(c_hh2, size(I_hh2));

p_ll3 = reshape(c_ll3, size(I_ll3));
p_lh3 = reshape(c_lh3, size(I_lh3));
p_hl3 = reshape(c_hl3, size(I_hl3));
p_hh3 = reshape(c_hh3, size(I_hh3));
%% Back to image
ll_kmeans = mat2gray(p_ll);
lh_kmeans = mat2gray(p_lh);
hl_kmeans = mat2gray(p_hl);
hh_kmeans = mat2gray(p_hh);

ll2_kmeans = mat2gray(p_ll2);
lh2_kmeans = mat2gray(p_lh2);
hl2_kmeans = mat2gray(p_hl2);
hh2_kmeans = mat2gray(p_hh2);

ll3_kmeans = mat2gray(p_ll3);
lh3_kmeans = mat2gray(p_lh3);
hl3_kmeans = mat2gray(p_hl3);
hh3_kmeans = mat2gray(p_hh3);
%% Final Plotting
figure('Name', 'K-Means Clustering Post-DWT & Entropy Filtering Layer 1', 'NumberTitle', 'off');
subplot(2,2,1);imshow(ll_kmeans, []);title('LL');
subplot(2,2,2);imshow(lh_kmeans, []);title('LH');
subplot(2,2,3);imshow(hl_kmeans, []);title('HL');
subplot(2,2,4);imshow(hh_kmeans, []);title('HH');

figure('Name', 'K-Means Clustering Post-DWT & Entropy Filtering Layer 2', 'NumberTitle', 'off');
subplot(2,2,1);imshow(ll2_kmeans, []);title('LL2');
subplot(2,2,2);imshow(lh2_kmeans, []);title('LH2');
subplot(2,2,3);imshow(hl2_kmeans, []);title('HL2');
subplot(2,2,4);imshow(hh2_kmeans, []);title('HH2');

figure('Name', 'K-Means Clustering Post-DWT & Entropy Filtering Layer 3', 'NumberTitle', 'off');
subplot(2,2,1);imshow(ll3_kmeans, []);title('LL3');
subplot(2,2,2);imshow(lh3_kmeans, []);title('LH3');
subplot(2,2,3);imshow(hl3_kmeans, []);title('HL3');
subplot(2,2,4);imshow(hh3_kmeans, []);title('HH3');