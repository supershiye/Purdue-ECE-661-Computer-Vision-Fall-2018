%% ECE 661 2018 Fall Homework 7
% Ye Shi
% shi349@purdue.edu

function [CM,rate] = findConfusion(testing)
turelabel = extractfield(testing,'label');
pred = extractfield(testing,'predict');
CM = zeros(5);
for i = 1:length(turelabel)
    CM(turelabel(i),pred(i)) = CM(turelabel(i),pred(i))+1;
end
rate = sum(diag(CM))/length(turelabel);
end