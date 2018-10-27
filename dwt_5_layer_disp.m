close all;

dcm_dir = 'dicom_dir/';

%Calculate number of dicom files in dicom_dir 
imagefiles = dir('dicom_dir/*.dcm');
nfiles = length(imagefiles);

%For each *.dcm file in the dataset, load it and add it to the images array
for inum=1:nfiles
    curr_name = imagefiles(inum).name;
    curr_dcm = dicomread(strcat(dcm_dir, curr_name));
    images{inum} = curr_dcm;
end
%images array now contains the entire dataset of dicom files

sX=size(images{5});

%Splits image into 4 layers
[LL,LH,HL,HH]=dwt2(images{5},'haar');
[LL2, LH2, HL2 ,HH2] = dwt2(LL, 'haar');
[LL3, LH3, HL3, HH3] = dwt2(LL2, 'haar');
[LL4, LH4, HL4, HH4] = dwt2(LL3, 'haar');
[LL5, LH5, HL5, HH5] = dwt2(LL4, 'haar');

%Create the figure to display output
figure(1)
subplot(5,4,1);imshow(LL);title('LL band of image');
subplot(5,4,2);imshow(LH);title('LH band of image');
subplot(5,4,3);imshow(HL);title('HL band of image');
subplot(5,4,4);imshow(HH);title('HH band of image');
subplot(5,4,5);imshow(LL2);title('LL2 band of image');
subplot(5,4,6);imshow(LH2);title('LH2 band of image');
subplot(5,4,7);imshow(HL2);title('HL2 band of image');
subplot(5,4,8);imshow(HH2);title('HH2 band of image');
subplot(5,4,9);imshow(LL3);title('LL3 band of image');
subplot(5,4,10);imshow(LH3);title('LH3 band of image');
subplot(5,4,11);imshow(HL3);title('HL3 band of image');
subplot(5,4,12);imshow(HH3);title('HH3 band of image');
subplot(5,4,13);imshow(LL4);title('LL4 band of image');
subplot(5,4,14);imshow(LH4);title('LH4 band of image');
subplot(5,4,15);imshow(HL4);title('HL4 band of image');
subplot(5,4,16);imshow(HH4);title('HH4 band of image');
subplot(5,4,17);imshow(LL5);title('LL5 band of image');
subplot(5,4,18);imshow(LH5);title('LH5 band of image');
subplot(5,4,19);imshow(HL5);title('HL5 band of image');
subplot(5,4,20);imshow(HH5);title('HH5 band of image');
X = idwt2(LL,LH,HL,HH,'haar',sX);

imshow(X);