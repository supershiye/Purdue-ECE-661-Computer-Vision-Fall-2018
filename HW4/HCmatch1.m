function [SR,NR] = HCmatch1(HR1,HR2, winSize)

[h1,w1] = size(HR1);
[h2,w2] = size(HR2);

if nargin < 3
    %     winSize = round(h1/10)*2 +1;
    winSize = 101
end
hW = floor(winSize/2);
Scount = 0;
Ncount = 0;



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

SR = inf(l1,5);
NR = zeros(l1,5);

count = 0;

for c = 1:l1
    i = x(c);
    j = y(c);
    I1 = HR1(i-hW: i+hW, j - hW: j + hW);
    % NCC
    m1 = mean(I1(:));
    T1 = I1-m1;
  
    
    for d = 1:l2

        count = count+1;
        m = a(d);
        n = b(d);
        % SSD
        I2 = HR2(m-hW: m+hW, n - hW: n + hW);
        ssd = sum(sum((I1-I2).^2));

        if ssd <= SR(c,1)
            SR(c,:) = [ssd i j m n];
        end

        % NCC
        m2 = mean(I2(:));
        T2 = I2-m2;
        ncc = sum(sum(T1.*T2)) / sqrt(sum(sum(T1.^2))*sum(sum(T2.^2)));
        if ncc >= NR(c,1)
            NR(c,:) = [ncc i j m n];
        end

    end
    
end
maxNR = max(NR(:,1))
NR(find(NR(:,1) < 0.6*maxNR),:) = [];

minSR = min(SR(:,1))
SR(find(SR(:,1) > 2*minSR),:) = [];

numNR = size(NR,1)
numSR = size(SR,1)
% Scount
% Ncount
% if Scount ~= 0
% maxSR = max(SR(:,1))
% end
% if Ncount ~=0
% minNR = min(NR(:,1))
% end

end

