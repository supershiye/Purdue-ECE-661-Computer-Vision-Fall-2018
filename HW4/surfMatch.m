%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function surfMatch(img1,img2,filename)
% This function is to perform SURF match process
I1 = rgb2gray(img1);
I2 = rgb2gray(img2);

% detect and generate SURF features
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

% match SURF features
indexPairs = matchSURF(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

pairs = [matchedPoints1.Location, matchedPoints2.Location];

% Plot the image
pltPairs(img1,img2,valid_points1.Location,valid_points2.Location ,pairs(:,[2,1,4,3]),[filename,'SURF'])

end