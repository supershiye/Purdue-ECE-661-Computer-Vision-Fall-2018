function R = HCD(img, scale, sigma)

if nargin < 2
    sigma = 1.2;
    scale = 1;
elseif nargin <3
    sigma = 1.2;
end

si = sigma* scale;

HaarSize = round(ceil(4*si)/2)*2;
HaarX = [-ones(HaarSize,HaarSize/2),ones(HaarSize,HaarSize/2)];
HaarY = - HaarX';

ImX = imfilter(img,HaarX,'same');
% figure()
% imshow(ImX)

ImY = imfilter(img,HaarY,'same');
% figure()
% imshow(ImY)
[h,w] = size(img);
R = zeros(h,w);

WinSize = round(ceil(5*si)/2)*2+1;
WShalf = floor(WinSize/2);
parfor i = WShalf + 1 : h - WShalf - 1
    for j =  WShalf + 1 : w - WShalf - 1
        R(i,j) = findC(i,j,ImX,ImY,WShalf);
    end
end

% threshold = (0.9 ) * max(max(R(find(R~=0))));
% R = R > threshold;
%
% BW = edge(R,'canny');
% R = BW;
% imshow(BW)

% threshold = (2.4 - 0.2* scale ) * mean(mean(R(find(R~=0))));
% threshold = (3 - 0.2* scale ) * mean(mean(R(find(R~=0))));



R = localMaxFilter(R);

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
    r = det(C)/trace(C);
    if r< 0
        r = 0;
    end
else
    r = 0;
end
end

function r = localMaxFilter(R)
[h,w] = size(R);
Z = zeros(h,w);
Rmean = mean(mean(R(find(R~=0))));
% Rmax = (0.97 ) * max(max(R(find(R~=0))));
win = floor(h/40)*2;
hwin = floor(win/2);
for i = 1+hwin:h-hwin-1
    for j = 1+hwin:w-hwin-1
        Rwin = R(i-hwin:i+hwin,j-hwin:j+hwin);
        rmax = max(Rwin(:));
        if R(i,j) == rmax && R(i,j)>Rmean
            Z(i,j) = 1;
        end
    end
end
r = Z;
end






