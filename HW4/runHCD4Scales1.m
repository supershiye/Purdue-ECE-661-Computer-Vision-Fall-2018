%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function runHCD4Scales1(CP1a,CP1b,Name)
% This function is the over all process to perform Harris Corners matching.

% Transfer images to grayscale
GP1a = rgb2gray(CP1a);
GP1b = rgb2gray(CP1b);

% set 4 scales
parfor scale = 1:4

% Find the Harris corners
HR1a{scale} = HCD1(GP1a,scale);
HR1b{scale} = HCD1(GP1b,scale);

% Match the images
[SR{scale},NR{scale}] = HCmatch2(HR1a{scale},HR1b{scale});

% Draw the image pairing by SSD
if length(SR{scale}) ~= 0
pltPairs1(CP1a,CP1b,HR1a{scale},HR1b{scale},SR{scale}(:,2:5),[Name,num2str(scale),'S'])
end

% Draw the image pairing by NCC
if length(NR{scale}) ~= 0
pltPairs1(CP1a,CP1b,HR1a{scale},HR1b{scale},NR{scale}(:,2:5),[Name,num2str(scale),'N'])
end
end
