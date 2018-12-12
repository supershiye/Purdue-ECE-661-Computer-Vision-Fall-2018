%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function f =  WorldPlot(X,CI1,CI2,points1,points2)
if nargin ==1
    f = figure;
    % Create boarder lines
    P1 = -X([1 2 3 4 1],:);
    P2 = -X([4 5 6 3],:);
    P3 = -X([2 7 6],:);
    P4 = -X([6 8],:);
    Plot3 = @(P) plot3(P(:,2),P(:,1),P(:,3),'Color','b','Marker','x');
    Plot3(P1);
    hold on
    Plot3(P2);
    hold on
    Plot3(P3);
    hold on
    Plot3(P4);
    hold on
    grid on;
    hold off
else
    % This function is to generate the required 3D plot
    f = figure;
    % s1 is the 3D world plane
    s1 = subplot(2,2,[1 2]);
    % Create boarder lines
    P1 = -X([1 2 3 4 1],:);
    P2 = -X([4 5 6 3],:);
    P3 = -X([2 7 6],:);
    P4 = -X([6 8],:);
    Plot3 = @(P) plot3(P(:,2),P(:,1),P(:,3),'Color','b','Marker','x');
    Plot3(P1);
    hold on
    Plot3(P2);
    hold on
    Plot3(P3);
    hold on
    Plot3(P4);
    hold on
    grid on;
    % s2 is images
    s2 = subplot(2,2,[3 4]);
    showMatchedFeatures(CI1,CI2,points1,points2,'montage');
    hold off;
end
end
