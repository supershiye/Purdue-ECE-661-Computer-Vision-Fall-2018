%% ECE 661 2018 Fall Homework 6
% Ye Shi
% shi349@purdue.edu

close all;clear; clc;

%% Import images
baby = imread("baby.jpg");
lighthouse = imread("lighthouse.jpg");
ski = imread("ski.jpg");

%% Otsu Segmentation using RGB values
FinalPlot(baby,'Otsu','baby')
FinalPlot(lighthouse,'Otsu','lighthouse')
FinalPlot(ski,'Otsu','ski')

%% Otsu Segmentation using RGB values 2nd iteration
babyO2 = imread("baby_Otsu_foreground.png");
lighthouseO2 = imread("lighthouse_Otsu_background.png");
skiO2 = imread("ski_Otsu_foreground.png");
FinalPlot(babyO2,'Otsu','baby_2nd')
FinalPlot(lighthouseO2,'Otsu','lighthouse_2nd')
FinalPlot(skiO2,'Otsu','ski_2nd')

%% Otsu Segmentation using RGB values 3rd iteration
babyO3 = imread("baby_2nd_Otsu_foreground.png");
lighthouseO3 = imread("lighthouse_2nd_Otsu_foreground.png");
skiO3 = imread("ski_2nd_Otsu_foreground.png");
FinalPlot(babyO3,'Otsu','baby_3rd')
FinalPlot(lighthouseO3,'Otsu','lighthouse_3rd')
FinalPlot(skiO3,'Otsu','ski_3rd')



%% Texture Based Segmentation using 3 window size (3,5,7)

FinalPlot(baby,'TBS','baby')
FinalPlot(lighthouse,'TBS','lighthouse')
FinalPlot(ski,'TBS','ski')

%% Texture Based Segmentation using 3 window size (3,5,7) 2nd Iteration
babyT2 = imread("baby_TBS_foreground.png");
lighthouseT2 = imread("lighthouse_TBS_foreground.png");
skiT2 = imread("ski_TBS_background.png");
FinalPlot(babyT2,'TBS','baby_2nd')
FinalPlot(lighthouseT2,'TBS','lighthouse_2nd')
FinalPlot(skiT2,'TBS','ski_2nd')

%% Texture Based Segmentation using 3 window size (3,5,7) 3rd Iteration
babyT3 = imread("baby_2nd_TBS_foreground.png");
lighthouseT3 = imread("lighthouse_2nd_TBS_foreground.png");
skiT3 = imread("ski_2nd_TBS_foreground.png");
FinalPlot(babyT3,'TBS','baby_3rd')
FinalPlot(lighthouseT3,'TBS','lighthouse_3rd')
FinalPlot(skiT3,'TBS','ski_3rd')