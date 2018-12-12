clear;clc;close all
% CP1a = imread([pwd,'\HW4Pics\pair1\1.jpg']);
% CP1b = imread([pwd,'\HW4Pics\pair1\2.jpg']);
CP1a = imresize(imread([pwd , '\MyPics\shelf1.jpg']),[800,600]);
CP1b = imresize(imread([pwd , '\MyPics\Shelf2.jpg']),[800,600]);
Name = 'test'
scale = 4
GP1a = rgb2gray(CP1a);
GP1b = rgb2gray(CP1b);
HR1a = HCD1(GP1a,scale);
HR1b = HCD1(GP1b,scale);

[SR,NR] = HCmatch3(HR1a,HR1b);
% 
% pltPairs1(CP1a,CP1b,HR1a, HR1b,SR(:,2:5),[Name,num2str(scale),'S'])
% pltPairs1(CP1a,CP1b,HR1a, HR1b,NR(:,2:5),[Name,num2str(scale),'N'])