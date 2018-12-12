%% ECE 661 2018 Fall Homework 9 Part 1
% Ye Shi
% shi349@purdue.edu
%

function [data, label] = loadimg(foldername)
%% Load dataset
% data is the datamatrix, each row is a image vector
% label is a the true label vector
filePath = dir(foldername);
filePath([1, 2]) = [];
n = length(filePath);
i = 1;
vec = readImg([filePath(i).folder,'\',filePath(i).name]);
m = length(vec);
data = zeros(n,m);
data(i,:) = vec;
label = zeros(n,1);
label(i) = str2num(filePath(i).name([1,2]));
for i = 2:n
  data(i,:) = readImg([filePath(i).folder,'\',filePath(i).name]); 
  label(i) = str2num(filePath(i).name([1,2]));
end
data = normalize(data','scale');
end

function vec = readImg(path)
% this is to read images to vector
mat = rgb2gray(imread(path));
vec = mat(:)';
end
