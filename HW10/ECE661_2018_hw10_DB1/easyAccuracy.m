%% ECE 661 2018 Fall Homework 9 Part 1
% Ye Shi
% shi349@purdue.edu
%

function accuracy = easyAccuracy(trainProj,trainLabel,testProj,testLabel,k)
% This is an easy calculator for k-NN accuracy
if nargin <5
    k = 5;
end
t = size(testProj,2);
% Use a 5-NN classifier
Mdl=fitcknn(trainProj', trainLabel, 'NumNeighbors',k, 'distance', 'euclidean');
testPred= Mdl.predict(testProj');
accuracy =1 - sum(testPred~=testLabel)/t;
end