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

sX=size(images{1});

%Splits image into 4 layers
[cA,cH,cV,cD]=dwt2(images{1},'db1');

figure(1)
subplot(2,2,1);imshow(cA);title('cA band of image');
subplot(2,2,2);imshow(cH);title('cH band of image');
subplot(2,2,3);imshow(cV);title('cV band of image');
subplot(2,2,4);imshow(cD);title('cD band of image');
X = idwt2(cA,cH,cV,cD,'db1',sX);

figure(2)
imshow(X);