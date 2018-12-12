%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function [bestIdx,bestF] = ransacF(points1,points2)
% This function can find the most fitting F from pairs by RANSAC
% pairs is the set of all matched points.
nt= size(points1,1); % Total number of matches
% parameters:
p = .8; % The probability that at least one of the N trials will be free of outliers.
m = 8; % the set of correspondences for calculating F in each trial.
esp = 0.2; % the rough estimation of false correspondences from the total set.
del = 20; % The decision threshold to construct the inlier set.
N  = ceil(log(1-p)/log(1-(1-esp)^m));% Number of trials
M = floor((1-esp)*nt); % A minimum value for the size of the inlier set for it to be acceptable

Maxcount = 0;
bestF  = zeros(3);
bestIdx = zeros(nt,1);

for i = 1:N
    randRowIdx = randsample(nt,m);
    F = findF(points1(randRowIdx,:),points2(randRowIdx,:));
    if rank(F) == 2
        [~,P2] = findP(F);
        estPoints2 = P2*[points1';zeros(1,nt);ones(1,nt)];
        estPoints2 = estPoints2(1:2,:)./ estPoints2(end,:);
        dist  = sum(abs( (estPoints2 - points2')));
        inIdx = find(dist<del);
        count = length(inIdx); % use a naive cheese board distance
        if count > M &&  count > Maxcount
            bestF = F;
            bestIdx = inIdx;
            Maxcount = count;
        end
    end
end
if sum(bestIdx) == 0
    error('No inline pairs found!');
end
end