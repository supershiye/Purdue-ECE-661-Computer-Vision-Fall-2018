%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

close all;clear; clc;

%% read all images
img = cell(5,1);
for i = 1:5
    img{i} = imresize(imread([pwd , '\MyPics\',num2str(i),'.jpg']),[900,1200]);
% img{i} = imread([pwd , '\MyPics\',num2str(i),'.jpg']);
end

%% Auto Homography Calculation
H = cell(4,1);
Newimg = cell(4,1);
for i = 1:4 % i=1 corresponds to 1.jpg to 2.jpg
    H{i} = AuHoCa(img{i},img{i+1},[num2str(i),'To',num2str(i+1)]);
    projectH(img{i},img{i+1},H{i},1,[num2str(i),'To',num2str(i+1)]);
    Newimg{i} = projectH(img{i},img{i+1},H{i},0,[num2str(i),'To',num2str(i+1)]);
end

%% Mosaicing 5 pictures
Finalimg = mosaicing5(img,H,['SuperFinal']);