%% ECE 661 2018 Fall Homework 9 Part 2
% Ye Shi
% shi349@purdue.edu
%

function idxPos = cascadeAdaBoost(trainSet, Npos, idxPos, stage)
% to cascade AdaBoost in each iteartions
% trainSet - training dataset with row as features and column as samples
% Npos - number of rest positive samples
% idxPos - index of rest positive samples
% stage - Cascade stage number
fprintf('%d stage classifier\n', stage);
Ntotal = length(idxPos); % Total Samples
Nneg = Ntotal - Npos; % New left negative sample numbers
% update train set
features = trainSet(:,idxPos);
% initialize weights to equally assigned
weight = zeros(Ntotal,1);
% initialize labels for posiive and negative samples
label = zeros(Ntotal,1);
for t = 1:Ntotal
    if t <= Npos
        weight(t) = 0.5 / Npos;
        label(t) = 1;
    else
        weight(t) = 0.5 / Nneg;
    end
end
%%  Adaboost process
T = 100; % max number of weak classifier
strongPred = zeros(Ntotal,1);
alpha = zeros(T,1);
ht = zeros(4,T);
hPred = zeros(Ntotal,T);
% %initialization of all weak classifier
% [currentMin, theta,p,idx, result] = findWeak(features, weight, label, Npos);
for t = 1:T
    % normalize weights
    weight = weight ./ sum(weight);
    % get the best weak classifier and the detection result
    [ht(:,t),hPred(:,t)] = findWeak(features, weight, label, Npos);
    
    % h trust factor
    alpha(t) = log((1-ht(1,t))/ht(1,t));
    
    % update weight
    weight = weight .* (ht(1,t)/(1-ht(1,t))) .^ (1-xor(label,hPred(:,t)));
    
    %     strong classifier
    sumh = hPred(:,1:t) * alpha(1:t,:);
    threshold = min(sumh(1:Npos));
    strongPred = sumh >= threshold;
    
    % compute true positive accuracy
    TPA(t) = sum(strongPred(1:Npos)) / Npos;
    % compute false positve accuracy
    FNA(t) = sum(strongPred(Npos+1:end)) / Nneg;
    TPA(t)
    FNA(t)
    if TPA(t) == 1 && FNA(t) <= 0.5
        break;
    end
    
    fprintf('    %d weak classifier\n', t);
end
%% update for next cascaded iteration
% sort negative, if there is false deteciton, there will be 1 at the end
[sortedNeg, idxNeg] = sort(strongPred(Npos+1:end));
% get false detection negative index
for t = 1:Nneg
    if sortedNeg(t) > 0
        idxNeg = idxNeg(t:end);
        break;
    end
end
% get sample index for next cascaded iteration
idxPos = [1:Npos, Npos+idxNeg'];
% paremeters for each sum of classifiers
save(['ht_',num2str(stage),'.mat'],'ht','-mat', '-v7.3');
% alpha for each weak classifier
save(['alpha_',num2str(stage),'.mat'],'alpha','-mat', '-v7.3');
% threshold for whole sum of  classifier
save(['threshold_',num2str(stage),'.mat'],'threshold','-mat', '-v7.3');
end

function [ht,result] = findWeak(features, weight, label, Npos)
% Find the weak classifier of AdaBoost
[m,n] = size(features);
currentMin = inf;
tPos = repmat(sum(weight(1:Npos,1)), n,1);
tNeg = repmat(sum(weight(Npos+1:n,1)), n,1);
% search each feature as a classifier for image implemention
for i = 1: m
    % get one feature for all images
    eachFeature = features(i,:);
    % sort feature to thresh for postive and negative
    [sortedFeature, sortedIdx] = sort(eachFeature, 'ascend');
    % sort weights and labels
    sortedWeight = weight(sortedIdx);
    sortedLabel = label(sortedIdx);
    % select threshold
    sPos = cumsum(sortedWeight .* sortedLabel);
    sNeg = cumsum(sortedWeight) - sPos;
    errPos = sPos + (tNeg - sNeg);
    errNeg = sNeg + (tPos - sPos);
    
    % choose the threshold with small error
    allErrMin = min(errPos, errNeg);
    [errMin, idxMin] = min(allErrMin);
    
    % result
    result = zeros(n,1);
    if errPos(idxMin) <= errNeg(idxMin)
        p = -1;
        result(idxMin+1:end) = 1;
        result(sortedIdx) = result;
    else
        p = 1;
        result(1:idxMin) = 1;
        result(sortedIdx) = result;
    end
    
    % get best parameters
    if errMin < currentMin
        currentMin = errMin;
        if idxMin==1
            theta = sortedFeature(1) - 0.01;
        elseif idxMin==m
            theta = sortedFeature(m) + 0.01;
        else
            theta = (sortedFeature(idxMin)+sortedFeature(idxMin-1))/2;
        end
        
        idx = i;
    end
    
end % end of search each feature
ht = [currentMin, theta, p, idx]';
end
