%%This is a test script for texture analysis on tiff files.

%% Start with clean slate
clear all; close all; clc; imtool close all;
set(0, 'DefaultFigureWindowStyle','docked');

%% Read tiff file
%%hWaitBar = waitbar(0, 'Reading TIFF files');
I = imread('ID_0000_AGE_0060_CONTRAST_1_CT.tif');

%% Perform entropy filtering using entropyfilt.
J = entropyfilt(I);

%% Perform range filtering using rangefilt.
K = rangefilt(I);

%% Perform std filtering using stdfilt.

L = stdfilt(I);

%% Create a Grey-Scale Matrix
[glcm_original,SI] = graycomatrix(I,'Offset',[2 0],'Symmetric',true);
%glcm_original;
glcm_original = graycomatrix(I,'Offset',[2 0])

[glcm_entropy,SI] = graycomatrix(J,'Offset',[2 0],'Symmetric',true);
%glcm_entropy;
glcm_entropy = graycomatrix(J,'Offset',[2 0])

[glcm_range,SI] = graycomatrix(K,'Offset',[2 0],'Symmetric',true);
%glcm_range;
glcm_range = graycomatrix(K,'Offset',[2 0])

[glcm_std,SI] = graycomatrix(L,'Offset',[2 0],'Symmetric',true);
%glcm_std;
glcm_std = graycomatrix(L,'Offset',[2 0])

%csvwrite('data.csv',glcm_original);
%csvwrite('data.csv',glcm_entropy);
%csvwrite('data.csv',glcm_range);
%csvwrite('data.csv',glcm_std);

%% Subplots for filtering images

figure('Name','Filter Types of TIFF Images','NumberTitle','off');
subplot(1,4,1);imshow(I, []);title('Original Image');
subplot(1,4,2);imshow(J, []);title('Entropy Filter');
subplot(1,4,3);imshow(K, []);title('Range Filter');
subplot(1,4,4);imshow(L, []);title('STD Filter');



