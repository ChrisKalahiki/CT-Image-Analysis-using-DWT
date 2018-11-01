%%This is a test script for texture analysis on tiff files.

%% Read tiff file
%%hWaitBar = waitbar(0, 'Reading TIFF files');
I = imread('ID_0000_AGE_0060_CONTRAST_1_CT.tif');

%% Perform entropy filtering using entropyfilt.
J = entropyfilt(I);

%% Show the original image and the processed image.
imshow(I)
title('Original Image')

%% Show the image after filtering
figure
imshow(J,[])
title('Result of Entropy Filtering')

%% Create a Grey-Scale Matrix
%%[glcm,SI] = graycomatrix(I,'Offset',[2 0],'Symmetric',true);
glcm = graycomatrix(I,'Offset',[2 0])
glcm

csvwrite('data.csv',glcm);


