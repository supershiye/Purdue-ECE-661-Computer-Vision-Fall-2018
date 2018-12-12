%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

function [bestIdx,bestH] = ransacH(pairs)
% This function can find the most fitting Homograpy from pairs by RANSAC
% pairs is the set of all matched points.
nt= size(pairs,1); % Total number of matches
% parameters:
p = .99; % The probability that at least one of the N trials will be free of outliers.
m = 9; % the set of correspondences for calculating homography matrix H in each trial.
esp = 0.2; % the rough estimation of false correspondences from the total set.
del = 20; % The decision threshold to construct the inlier set.
N  = ceil(log(1-p)/log(1-(1-esp)^m))% Number of trials
M = floor((1-esp)*nt) % A minimum value for the size of the inlier set for it to be acceptable

Maxcount = 0;
bestH  = zeros(3);
bestIdx = zeros(nt,1);
for i = 1:N
    randRowIdx = randsample(nt,m);
    H = findH(pairs(randRowIdx,:));
    estPoints = H*[pairs(:,1:2)';ones(1,nt)];
    estPoints = estPoints./ estPoints(end,:);
    dist  = sum(abs( (estPoints(1:2,:) - pairs(:,3:4)')))
    inIdx = find(dist<del);
    count = length(inIdx) % use a naive cheese board distance
    if count > M &&  count > Maxcount 
        bestH = H
        bestIdx = inIdx;
        Maxcount = count
    end
end
if sum(bestIdx) == 0
    error('No inline pairs found!');
end


end