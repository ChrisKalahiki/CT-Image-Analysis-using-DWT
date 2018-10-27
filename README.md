# Introduction
Using discrete wavelet transform for feature extraction of CT medical images. We aim to identify outliers that may be caused by poor calibration of the machine or other outliers.

# Data Set
CT scans of lungs
• dicom_dir contains 100 CT scans in the DICOM format
• tiff_images contains the same 100 CT scans in the TIFF format

# Files
dwt_wavelet_name.m
• Simple dwt reconstruction of a wave. Plotted with labels

dwt_wavelet_and_scaling_features.m
• Adds scaling features to the previous file

dwt_image.m
• First attempt at using dwt functionality on an image

dwt_5_layers_disp.m
• Explored further extraction on one of the images from the dataset
• Display all of the layers that were extracted

scratchwork.m
• Where I work on the next step of the process.
• Currently using it to try and format a 2D array to store all of the sub-images for each DICOM file
