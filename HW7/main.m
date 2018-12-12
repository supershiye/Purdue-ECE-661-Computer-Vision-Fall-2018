%% ECE 661 2018 Fall Homework 7
% Ye Shi
% shi349@purdue.edu

close all;clear; clc;
grayread = @(x) rgb2gray(imread(x));
label = {'beach','building','car','mountain','tree'};

%% Import training images
Training = struct('data',[],'label',[],'LBP',[]);
num = 0;
for l = 1:5
    for i = 1:20
        num = num+1;
        if strcmp(label{l},'beach')
            Training(num).data = grayread([pwd,'\imagesDatabaseHW7\training\',label{l},...
                '\',num2str(i),'.jpg']);
        else
            Training(num).data = grayread([pwd,'\imagesDatabaseHW7\training\',label{l},...
                '\',num2str(i,'%02d'),'.jpg']);
        end
        Training(num).label=l;
    end
end

%% find LBP of the trainning set
parfor i = 1:num
    Training(i).LBP = findLBP(Training(i).data);
end
TrainingLBP  = reshape(extractfield(Training,'LBP'),10,num)';
TrainingLabel  = extractfield(Training,'label');

%% Import Test images
testing = struct('data',[],'label',[],'LBP',[],'predict',[]);
files = dir('imagesDatabaseHW7\testing');
num = 0;
for i = 3:numel(files)
    num = num+1;
    testing(num).data = grayread([files(i).folder,'\',files(i).name]);
    for l = 1:5
        len = length(label{l});
        if strcmp(label{l},files(i).name(1:len))
            testing(num).label = l;
        end
    end
end

%% find LBP of the test set and predict
parfor i = 1:num
    testing(i).LBP = findLBP(testing(i).data);
end
%% 5NN classify

% normalize the training data
% TrainingLBP = normalize(TrainingLBP,2,'range');
% parfor i = 1:num
%     testing(i).predict = LBP5NN(normalize(testing(i).LBP,2,'range'),TrainingLBP,TrainingLabel);
% end
num = 25;
parfor i = 1:num
    testing(i).predict = LBP5NN(testing(i).LBP,TrainingLBP,TrainingLabel);
end

%% Examples of LBP histograms
num = 100
for i = 1:num
    if mod(i,20) == 1
        f=figure;
        bar(Training(i).LBP);
        xticklabels({'0','1','2','3','4','5','6','7','8','9'});
        saveas(f, ['LBP',num2str(i),'.png']);
    end
end
close all

%% Confusion Matrix
[CM,rate] = findConfusion(testing)

%% Save Result
save('final.mat')