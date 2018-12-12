%% ECE 661 2018 Fall Homework 9 Part 1
% Ye Shi
% shi349@purdue.edu

function  WT = findLDA(data,label)
%% to find the LDA projection matrix
class = unique(label);
N = length(class); % number of class
[m,n] = size(data);
M = mean(data,2);
Mc = zeros(m,N); % mean of each class
Xw = []; 
for i = class'
    Mc(:,i) = mean(data(:,find(label==i)),2);
    Xw = [Xw , data(:,find(label==i)) - Mc(:,i)];
end
% Yu and Yang's Algorithm
[V,D] = eig(1/N *(Mc-M)'*(Mc-M));
V = V(:,find(diag(D)>0));
D = D(find(diag(D)>0),find(diag(D)>0));
[d,ind] = sort(diag(D),'descend');
DB = D(ind,ind);
u = V(:,ind);
Y = (Mc-M)*u;
Z = Y*inv(sqrt(DB));
G = Z'*Xw;
[U,~] = eig( G*G');
WT = U'*Z';
end
