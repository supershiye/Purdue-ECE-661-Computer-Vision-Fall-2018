%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function R = HCD1(img, scale, sigma)
% Find the Harris Corner map of img
% scale is a mutiplier
% 
if nargin < 2
    sigma = 1.2;
    scale = 1;
elseif nargin <3
    sigma = 1.2;
end

debug = 0

si = sigma * scale;

HaarSize = round(ceil(4*si)/2)*2;
HaarX = [-ones(HaarSize,HaarSize/2),ones(HaarSize,HaarSize/2)];
HaarY = - HaarX';

ImX = imfilter(img,HaarX,'same');
ImY = imfilter(img,HaarY,'same');

[h,w] = size(img);
R = zeros(h,w);

WinSize = round(ceil(5*si)/2)*2+1;
WShalf = floor(WinSize/2);
parfor i = WShalf + 1 : h - WShalf - 1
    for j =  WShalf + 1 : w - WShalf - 1
        R(i,j) = findC(i,j,ImX,ImY,WShalf);
    end
end

% debug use to show HCD points
if debug
    figure;imshow(img);hold on;
%     [x,y] = find(R);
%     plot(y,x,'x');
%     hold on;
end

R = localMaxFilter(R,si);

% debug use to show HCD points
if debug
    [x,y] = find(R);
    plot(y,x,'o');
    hold off;
end
Rnum = length(find(R))
end

function r = findC(i,j,ImX,ImY,WShalf)
Ix = ImX(i - WShalf : i+ WShalf, j - WShalf : j+ WShalf);
Iy = ImY(i - WShalf : i+ WShalf, j - WShalf : j+ WShalf);
C = zeros(2,2);
C(1,1) = sum(Ix(:).^2);
C(2,2) = sum(Iy(:).^2);
C(1,2) = sum(Ix(:).*Iy(:));
C(2,1) = C(1,2);

if rank(C) == 2
%     r = det(C)/trace(C)^2;
r = det(C) - 0.04*trace(C)^2;
    if r< 0
        r = 0;
    end
else
    r = 0;
end
end

function r = localMaxFilter(R,si)
[h,w] = size(R);
Z = zeros(h,w);
Rmean = mean(R(find(R>0)))
Rmax = max(R(find(R>0)))
Rmin = min(R(find(R>0)))
threshold = Rmean
MSwin= 21
hwin = floor(MSwin/2);
for i = 1+hwin:h-hwin-1
    for j = 1+hwin:w-hwin-1
        Rwin = R(i-hwin:i+hwin,j-hwin:j+hwin);
        rmax = max(Rwin(:));
        if rmax ~=0
            if R(i,j) == rmax && R(i,j)>threshold
                Z(i,j) = R(i,j);
                %                 Z(i,j) =1;  % only for cornet bit map
            end
        end
    end
end
% r = Z/max(Z(:));
r = Z;
end






