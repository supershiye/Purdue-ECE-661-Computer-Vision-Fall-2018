%% ECE 661 2018 Fall Homework 8
% Ye Shi
% shi349@purdue.edu

function [R,t] = findRt(H,K)
% Find the external camera calibration matrix
% R rotation
% t tranfer
% H homography
% K intrinsic camera matrix
K_inv = K^-1;
t = K_inv*H(:,3);
mag = norm(K_inv*H(:,1));
if(t(3)<0)
    mag = -mag;
end
r1 = K_inv*H(:,1)/mag;
r2 = K_inv*H(:,2)/mag;
r3 = cross(r1,r2);
R = [r1 r2 r3];
t = t/mag;
[U,~,V] = svd(R);
R = U*V';

% Convert to the R,t using Rodriguez formula
R =rotationVectorToMatrix(rotationMatrixToVector(R));
end