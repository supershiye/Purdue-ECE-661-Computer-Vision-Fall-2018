%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function X = findX(P1,P2,points1,points2)
% This is to find world frame X
n = size(points1,1);
X = zeros(n,3);
for i = 1:n
    A = [ (points1(i,1)*P1(3,:) -P1(1,:));
        (points1(i,2)*P1(3,:) -P1(2,:));
        (points2(i,1)*P2(3,:) -P2(1,:));
        (points2(i,2)*P2(3,:) - P2(2,:)) ];
    
    [~ ,~, V]=svd(A);
    x=V(:,4);
    x=x(1:3)/x(end);
    X(i,:)=x;
end
end