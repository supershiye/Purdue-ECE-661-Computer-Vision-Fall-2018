%% ECE 661 2018 Fall Homework 9 Part 2
% Ye Shi
% shi349@purdue.edu
%

function predict = AdaBoostClassifier( testSet, alpha, p, theta, fIdx, T)
% To classify by Cascade Adaboost
% get number of test samples
N = size(testSet,2);
% result for each weak classifier
weakResult = zeros(N,T);
% classify using every weak classiier
for t = 1:T
    % get classifier feature
    feature = testSet(fIdx(t),:);
    
    % do classification for each test image
    for i = 1:N
        if p(t)*feature(i) <= p(t)*theta(t)
            weakResult(i,t) = 1;
        end
    end
end
% build strong classifier
strongCla = weakResult(:,1:T) * alpha(1:T,:);
% compute strong classifier thershold
strongThreshold = 0.5 * sum(alpha(1:T,1));
% get final classification result
predict = zeros(N,1);
for i = 1:N
    if strongCla(i) >= strongThreshold
        predict(i) = 1;
    end
end
end