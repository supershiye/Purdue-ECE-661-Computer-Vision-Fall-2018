clear;clc
%%
CP1a = imread([pwd,'\HW4Pics\pair1\1.jpg']);
CP1b = imread([pwd,'\HW4Pics\pair1\2.jpg']);
runHCD4Scales(CP1a,CP1b,'P1H')
%%
CP2a = imresize(imrotate(imread([pwd,'\HW4Pics\pair2\truck1.jpg']),-90),[800,600]);
CP2b = imresize(imrotate(imread([pwd,'\HW4Pics\pair2\truck1.jpg']),-90),[800,600]);
% CP2a = imrotate(imread([pwd,'\HW4Pics\pair2\truck1.jpg']),-90);
% CP2b = imrotate(imread([pwd,'\HW4Pics\pair2\truck1.jpg']),-90);
runHCD4Scales(CP2a,CP2b,'P2H')
%%
CPTa = imresize(imread([pwd , '\MyPics\tower1.jpg']),[600,800]);
CPTb = imresize(imread([pwd , '\MyPics\tower2.jpg']),[600,800]);
runHCD4Scales(CPTa,CPTb,'MTH')

%%
CPBa = imresize(imread([pwd , '\MyPics\bottle1.jpg']),[800,600]);
CPBb = imresize(imread([pwd , '\MyPics\bottle2.jpg']),[800,600]);
runHCD4Scales(CPBa,CPBb,'MBH')

%%
CPGa = imresize(imread([pwd , '\MyPics\gundam1.jpg']),[600,800]);
CPGb = imresize(imread([pwd , '\MyPics\gundam2.jpg']),[600,800]);
runHCD4Scales(CPGa,CPGb,'MGH')

%%
% CPSa = imresize(imread([pwd , '\MyPics\shelf1.jpg']),[600,800]);
% CPSb = imresize(imread([pwd , '\MyPics\shelf2.jpg']),[600,800]);
% runHCD4Scales(CPSa,CPSb,'MSH')