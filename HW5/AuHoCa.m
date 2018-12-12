%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

function H = AuHoCa(img1,img2,filename)
% Automatic Homography Calculator
% Find matched SURF features pairs
if nargin <3
    filename = datetime('today');
end

pairs =  surfMatch(img1,img2,filename);
% RANSAC
[bestIdx,~] = ransacH(pairs);


pltPairs(img1,img2,pairs, bestIdx,[filename,'S']);

% LM optimization
H = LMfindH(pairs(bestIdx,:));
end