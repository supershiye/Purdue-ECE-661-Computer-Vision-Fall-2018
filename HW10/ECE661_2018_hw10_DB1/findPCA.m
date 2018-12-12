%% ECE 661 2018 Fall Homework 9 Part 1
% Ye Shi
% shi349@purdue.edu

function  W = findPCA(data)
%% to find the PCA projection matrix
% Compute covariance matrix for sorting eigen values 
m = mean(data,2);
X = data - m;
[V,D]= eig(X'*X);
V = V(:,find(diag(D)>0));
D = D(find(diag(D)>0),find(diag(D)>0));
[d,ind] = sort(diag(D),'descend');
Ds = D(ind,ind);
Vs = V(:,ind);
W = X*Vs;
end