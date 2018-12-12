%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

close all;clear; clc;
L =@(l) latex(vpa(l.*(abs(l)>1e-3),4)) % quick latex generator
%% Import images and resize them
CI1 = imread('IMG_1809.JPG');
CI2 = imread('IMG_1810.JPG');
CI1 = imresize(CI1,[600,800]);
CI2 = imresize(CI2,[600,800]);
I1 = rgb2gray(CI1);
I2 = rgb2gray(CI2);
%% Points Preset
points1 =[   360   147
    213   217
    434   332
    566   224
    573   259
    431   377
    210   254
    433   426];

points2 =[   371   153
    214   216
    370   338
    540   241
    549   273
    372   379
    212   248
    378   425];
%% Visualization of matching points
if 1
    f = figure;
    showMatchedFeatures(CI1,CI2,points1,points2,'montage');
    hold off;
    img = getframe();
    imwrite(img.cdata,['selection.png']);
    close(f);
end



%% Find F, In the 1st round, we assume I1 is in the world plane
F0 = findF(points1,points2,1);
[P10, P20] = findP(F0);
X0 = findX(P10,P20,points1,points2);
[F,P1,e1,P2,e2,X] = refineF(F0,points1,points2)

%% Rectify the image
[H1,H2] = rectify(P1,P2,e1,e2,I1,I2,points1,points2);

rpoints1 = H1*[points1 ones(8,1)]'
rpoints1 = [rpoints1(1:2,:)./rpoints1(end,:)]'
rpoints2 = H2*[points2 ones(8,1)]'
rpoints2 = [rpoints2(1:2,:)./rpoints2(end,:)]'


%% Visualization of Rectification

if 1
    f  = figure
    t1 = maketform('projective',H1');
    [J1,xdata1,ydata1]= imtransform(CI1,t1);
    % Add offset for the projection
    dpoints1= rpoints1;
    dpoints1(:,1) = dpoints1(:,1) - xdata1(1);
    dpoints1(:,2) = dpoints1(:,2) - ydata1(1);
    t2 = maketform('projective',H2');
    [J2,xdata2,ydata2] = imtransform(CI2,t2);
    dpoints2= rpoints2;
    dpoints2(:,1) = dpoints2(:,1) - xdata2(1);
    dpoints2(:,2) = dpoints2(:,2) - ydata2(1);
    showMatchedFeatures(J1,J2,dpoints1,dpoints2,'montage');
    hold off;
    img = getframe();
    imwrite(img.cdata,['rectification.png']);
    close(f);
end
%% Find F, In the 1st round, we assume I1 is in the world plane
rF0 = findF(dpoints1,dpoints2,1);
[rF,rP1,re1,rP2,re2,rX] = refineF(F0,dpoints1,dpoints2)

%% Visualize All 3D plots
f = WorldPlot(X,CI1,CI2,points1,points2)
r = WorldPlot(rX,J1,J2,dpoints1,dpoints2)

