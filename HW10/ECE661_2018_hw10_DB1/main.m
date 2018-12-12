%% ECE 661 2018 Fall Homework 9 Part 1
% Ye Shi
% shi349@purdue.edu
%

clear;clc;close all;
%% Load dataset
[testData, testLabel] = loadimg("test"); % all data are normalized
[trainData, trainLabel] = loadimg("train");

%% PCA
W = findPCA(trainData); % W is the projection matrix
pca = size(W,2);

%% LDA
WT = findLDA(trainData,trainLabel); % WT is the projection matrix
lda = size(WT,1);

%% k-NN classifier for LDA and PCA
n = min([pca,lda]);
LDAaccuracy = zeros(n,1);
PCAaccuracy = zeros(n,1);
for p = 1:n
    LDAaccuracy(p) =easyAccuracy(WT(1:p,:)*trainData,trainLabel,WT(1:p,:)*testData,testLabel,1);
    PCAaccuracy(p) =easyAccuracy(W(:,1:p)'*trainData,trainLabel,W(:,1:p)'*testData,testLabel,1);
end

%% Plot comparsion figures
f = figure
plot(1:n,PCAaccuracy,'-x');
hold on;
plot(1:n,LDAaccuracy,'-+');
hold on;
legend({"PCA","LDA"});
hold on;
xlabel({"P features"});
hold on;
ylabel({"Accuracy"});
hold on;
axis([1 n 0 1.05]);
hold off
saveas(f,'PCAvsLDA.png');