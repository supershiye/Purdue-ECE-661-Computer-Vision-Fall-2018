%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function [P1,P2] = findP(F)
% This function is to find P and P' as P1,P2
P1 = [eye(3),zeros(3,1)];
e2 = null(F');
e2 = e2./e2(end);
e2x= [0 -e2(3) e2(2);e2(3) 0 -e2(1);-e2(2) e2(1) 0];
P2 = [e2x*F,e2];
end