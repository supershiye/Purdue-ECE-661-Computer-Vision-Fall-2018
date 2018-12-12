%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function [SSD,NCC] = HCmatch2(HR1,HR2, winSize)
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

% Filter out unsuitable values (another approah)
% It will restrict more pairs
% SRmin = min(min(SR(find(SR~=0))));
% SR(find(SR>= 100*SRmin)) = Inf;
% 
% NRmax = max(NR(:));
% NR(find(NR<= 0.8* NRmax)) = 0;

% Find the best value in both column and row
SRrowMin = Inf(l1,1);
SRcolumnIdx = zeros(l1,1);

SRcolumnMin = Inf(l2,1);
SRrowIdx = zeros(l2,1);

NRrowMax = zeros(l1,1);
NRcolumnIdx = zeros(l1,1);

NRcolumnMax = zeros(l2,1);
NRrowIdx = zeros(l2,1);

for c = 1:l1
    [SRrowMin(c), SRcolumnIdx(c)] = min(SR(c,:)) ;
    [NRrowMax(c), NRcolumnIdx(c)] = max(NR(c,:)) ;
end

for d = 1:l2
    [SRcolumnMin(d), SRrowIdx(d)] = min(SR(:,d)) ;
    [NRcolumnMax(d), NRrowIdx(d)] = max(NR(:,d)) ;
end

% Pairs will be saved in SSD and NCC

SSD = inf(min(l1,l2),5);
NCC = zeros(min(l1,l2),5);

Scount = 0;
Ncount = 0;

for c = 1:l1
    i = x(c);
    j = y(c);
    for d = 1:l2
        m = a(d);
        n = b(d);
        bestSR = min([SRrowMin(c),SRcolumnMin(d)]);
        if SR(c,d) == bestSR
            Scount = Scount+1;
            SR(c,:) = inf(1,l2);
            SR(:,d) = inf(l1,1);
            SR(c,d) = bestSR;
            SSD(Scount,:) = [bestSR i j m n];
            
        end
        
        bestNR = max([NRrowMax(c),NRcolumnMax(d)]);
        
        if NR(c,d) == bestNR
            Ncount = Ncount+1;
            NR(c,:) = zeros(1,l2);
            NR(:,d) = zeros(l1,1);
            NR(c,d) = bestNR;
            NCC(Ncount,:) = [bestNR i j m n];
        end
    end
end

% This is another approach to keep more pairs
% SSD = inf(l1+l2,5);
% NCC = zeros(l1+l2,5);

% for c = 1:l1
%     i = x(c);
%     j = y(c);
%     m = a( SRcolumnIdx(c));
%     n = b( SRcolumnIdx(c));
%     Scount = Scount+1
%     SSD(Scount,:) = [SRrowMin(c) i j m n];
%     
% 
%     m = a( NRcolumnIdx(c));
%     n = b( NRcolumnIdx(c));
%     Ncount = Ncount+1
%     NCC(Ncount,:) = [NRrowMax(c) i j m n];   
% end

% Delete non-used values
NCC(find(NCC(:,1)==0),:) = [];
SSD(find(SSD(:,1) == inf),:) =[];
numNCC = size(NCC,1)
numSSD = size(SSD,1)


end

