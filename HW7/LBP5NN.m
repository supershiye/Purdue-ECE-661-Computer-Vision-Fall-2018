%% ECE 661 2018 Fall Homework 7
% Ye Shi
% shi349@purdue.edu

function L = LBP5NN(testing, training, traininglabels)
% 5-NN for LBP
dist = vecnorm(testing - training,2,2);
[~,I] = sort(dist,'ascend');
L = mode(traininglabels(I(1:3)));
end
