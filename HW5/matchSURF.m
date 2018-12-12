%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function index=matchSURF(f1,f2)
% This function is to match SURF features
l1 = size(f1,1);
l2 = size(f2,1);

R = inf(l1,l2);

for i = 1:l1
    for j = 1:l2
        R(i,j) = norm(f1(i,:)-f2(j,:));
    end
end

[idx1,idx2] = find(R <=0.1);
index = [idx1,idx2];
end