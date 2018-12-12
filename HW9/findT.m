%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu


function T = findT(points)
% Find the normalizion matrix T
% Find mean of the interest points
mu = mean(points);
d = points-repmat(mu,size(points,1),1);
d = sqrt(d(:,1).^2+d(:,2).^2);
dmean = mean(d);
k = sqrt(2)/dmean;
x = -k*mu(1);
y = -k*mu(2);
T = [k 0 x; 0 k y ; 0 0 1];
end
