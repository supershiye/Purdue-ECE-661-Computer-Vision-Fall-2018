%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function [SSD,NCC] = HCmatch3(HR1,HR2, winSize)
% This function is for matching Harris Corners by the scale images HR1 and
% HR2 with using SSD and NCC. winSize is the window size for the silding 
% window to compute NCC and SSD.
% This is the 3rd version, which only match the best pair for over all
% pairs. It doesn't rely on thresholds.


[h1,w1] = size(HR1);
[h2,w2] = size(HR2);

if nargin < 3
    winSize = 80
end
hW = floor(winSize/2);

[x,y] = find(HR1(hW+1:h1-hW-1,hW+1:w1-hW-1 ) > 0);
x = x+hW;
y = y+hW;
l1 = length(x)
[a,b] = find(HR2(hW+1:h2-hW-1,hW+1:w2-hW-1 ) > 0);
a = a+hW;
b = b+hW;
l2 = length(b)

% Limit the loop times
lim = 1* min([l1,l2])

% SR and NR are 2 matrices to store all
SR = inf(l1,l2);
NR = zeros(l1,l2);

% Compute SSD and NCC for every pair of points
for c = 1:l1
    i = x(c);
    j = y(c);
    I1 = HR1(i-hW: i+hW, j - hW: j + hW);
    % NCC
    m1 = mean(I1(:));
    T1 = I1-m1;
    
    
    for d = 1:l2
        
        m = a(d);
        n = b(d);
        % SSD
        I2 = HR2(m-hW: m+hW, n - hW: n + hW);
        ssd = sum(sum((I1-I2).^2));
        SR(c,d) = ssd;
        
        % NCC
        m2 = mean(I2(:));
        T2 = I2-m2;
        ncc = sum(sum(T1.*T2)) / sqrt(sum(sum(T1.^2))*sum(sum(T2.^2)));
        NR(c,d) = ncc;
    end
    
end

SRmin = min(SR(:))
NRmax = max(NR(:))

[idx1,idy1] = find(SR<1.2*SRmin);
SSD = [SRmin*ones(length(idx1),1), x(idx1),y(idx1),a(idy1),b(idy1)];

[idx2,idy2] = find(NR >0.8*NRmax);
NCC = [NRmax*ones(length(idx2),1), x(idx2),y(idx2),a(idy2),b(idy2)];

end

