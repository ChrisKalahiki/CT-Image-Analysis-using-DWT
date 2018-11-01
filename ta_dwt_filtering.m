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
%{
[LL2, LH2, HL2 ,HH2] = dwt2(LL, 'haar');
[LL3, LH3, HL3, HH3] = dwt2(LL2, 'haar');
[LL4, LH4, HL4, HH4] = dwt2(LL3, 'haar');
[LL5, LH5, HL5, HH5] = dwt2(LL4, 'haar');
%} 

%% Filter dwt layers into entropy filtering
ll_post_filter = entropyfilt(LL);
lh_post_filter = entropyfilt(LH);
hl_post_filter = entropyfilt(HL);
hh_post_filter = entropyfilt(HH);

%% Create a Grey-Scale Matrix
%[glcm_ll,SI] = graycomatrix(ll_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_ll = graycomatrix(ll_post_filter,'Offset',[2 0])

%[glcm_lh,SI] = graycomatrix(lh_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_lh = graycomatrix(lh_post_filter,'Offset',[2 0])

%[glcm_hl,SI] = graycomatrix(hl_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_hl = graycomatrix(hl_post_filter,'Offset',[2 0])

%[glcm_hh,SI] = graycomatrix(hh_post_filter,'Offset',[2 0],'Symmetric',true);
glcm_hh = graycomatrix(hh_post_filter,'Offset',[2 0])

%% array for post matrices filtering and placing it in a csv file

array = [glcm_ll, glcm_lh, glcm_hl, glcm_hh]

csvwrite('post_dwt_ta_filter.csv', array)

%% Subplots for filtering images
%{
figure('Name','DWT Entropy Filtering','NumberTitle','off');
subplot(1,4,1);imshow(ll_post_filter, []);title('LL');
subplot(1,4,2);imshow(lh_post_filter, []);title('LH');
subplot(1,4,3);imshow(hl_post_filter, []);title('HL');
subplot(1,4,4);imshow(hh_post_filter, []);title('HH');
%}

