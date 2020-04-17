clear all;
close all;
clc;

addpath(genpath('sparsefusion'));
addpath(genpath('dtcwt_toolbox'));
addpath(genpath('fdct_wrapping_matlab'));
addpath(genpath('nsct_toolbox'));

load('sparsefusion/Dictionary/D_100000_256_8.mat');

[imagename1 imagepath1]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
image_input1=imread(strcat(imagepath1,imagename1));    
[imagename2 imagepath2]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
image_input2=imread(strcat(imagepath2,imagename2));     

figure;imshow(image_input1);
figure;imshow(image_input2);

if size(image_input1)~=size(image_input2)
    error('two images are not the same size.');
end

img1=double(image_input1);
img2=double(image_input2);

overlap = 6;                    
epsilon=0.1;
level=4;

% To make a comparison, please use 
% LP-SR for medical image fusion, 
% DTCWT-SR for visible-infrared image fusion,
% NSCT-SR for multi-focus image fusion.

tic;
if size(img1,3)==1    %for gray images
    imgf = lp_sr_fuse(img1,img2,level,3,3,D,overlap,epsilon);      %LP-SR
    %imgf = rp_sr_fuse(img1,img2,level,3,3,D,overlap,epsilon);     %RP-SR
    %imgf = dwt_sr_fuse(img1,img2,level,D,overlap,epsilon);        %DWT-SR
    %imgf = dtcwt_sr_fuse(img1,img2,level,D,overlap,epsilon);      %DTCWT-SR
    %imgf = curvelet_sr_fuse(img1,img2,level+1,D,overlap,epsilon); %CVT-SR
    %imgf = nsct_sr_fuse(img1,img2,[2,3,3,4],D,overlap,epsilon);   %NSCT-SR
else                  %for color images
    imgf=zeros(size(img1));
    for i=1:3
        imgf(:,:,i) = lp_sr_fuse(img1(:,:,i),img2(:,:,i),level,3,3,D,overlap,epsilon);      %LP-SR
        %imgf(:,:,i) = rp_sr_fuse(img1(:,:,i),img2(:,:,i),level,3,3,D,overlap,epsilon);     %RP-SR
        %imgf(:,:,i) = dwt_sr_fuse(img1(:,:,i),img2(:,:,i),level,D,overlap,epsilon);        %DWT-SR
        %imgf(:,:,i) = dtcwt_sr_fuse(img1(:,:,i),img2(:,:,i),level,D,overlap,epsilon);      %DTCWT-SR
        %imgf(:,:,i) = curvelet_sr_fuse(img1(:,:,i),img2(:,:,i),level+1,D,overlap,epsilon); %CVT-SR
        %imgf(:,:,i) = nsct_sr_fuse(img1(:,:,i),img2(:,:,i),[2,3,3,4],D,overlap,epsilon);   %NSCT-SR
    end
end
toc;

figure;imshow(uint8(imgf));
imwrite(uint8(imgf),'Results/fused_mstsr.tif');

