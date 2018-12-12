%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi349@purdue.edu

%% This is the main script
clear; clc; close all;
%% Building
CP1a = imread([pwd,'\HW4Pics\pair1\1.jpg']);
CP1b = imread([pwd,'\HW4Pics\pair1\2.jpg']);
surfMatch(CP1a,CP1b,'building')
%% Truck
CP2a = imresize(imrotate(imread([pwd,'\HW4Pics\pair2\truck1.jpg']),-90),[800,600]);
CP2b = imresize(imrotate(imread([pwd,'\HW4Pics\pair2\truck1.jpg']),-90),[800,600]);
surfMatch(CP2a,CP2b,'truck')

%% Books
CPGa = imresize(imread([pwd , '\MyPics\books1.jpg']),[600,800]);
CPGb = imresize(imread([pwd , '\MyPics\books2.jpg']),[600,800]);
surfMatch(CPGa,CPGb,'books')

%% Shelf
CPSa = imresize(imread([pwd , '\MyPics\shelf1.jpg']),[800,600]);
CPSb = imresize(imread([pwd , '\MyPics\Shelf2.jpg']),[800,600]);
surfMatch(CPSa,CPSb,'shelf')