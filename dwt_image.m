%This code splits a single dwt image into 4 layers
%Using a static dicom image in the main folder
clear all;
close all;
i=dicomread('image.dcm');
sX=size(i);
%Splits image into 4 layers
[LL,LH,HL,HH]=dwt2(i,'db1');
figure(1)
subplot(2,2,1);imshow(LL);title('LL band of image');
subplot(2,2,2);imshow(LH);title('LH band of image');
subplot(2,2,3);imshow(HL);title('HL band of image');
subplot(2,2,4);imshow(HH);title('HH band of image');
X = idwt2(LL,LH,HL,HH,'db1',sX);
figure(2)
%Displays each layer
imshow(X);