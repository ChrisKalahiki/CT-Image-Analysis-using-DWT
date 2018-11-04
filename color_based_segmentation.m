%% Start with clean slate
clear all; close all; clc; imtool close all;
set(0, 'DefaultFigureWindowStyle','docked');

%% Step 1
he = imread('tiff_images/ID_0000_AGE_0060_CONTRAST_1_CT.tif');
imshow(he), title('TIFF Image');

%% K-means clustering
I = im2double(he);
%disp(I);
c = kmeans(I(:), 7);
%disp(c);

%% reshape
p = reshape(c, size(I));

%% Output
%disp(p);

%% Back to image
image = mat2gray(p);
imshow(image);
