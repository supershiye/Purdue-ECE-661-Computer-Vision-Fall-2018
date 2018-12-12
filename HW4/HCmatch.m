function [SR,NR] = HCmatch(HR1,HR2, winSize)

[h1,w1] = size(HR1);
[h2,w2] = size(HR2);

if nargin < 3
    winSize = round((h1/20)/2)*2 +1 ;
end
hW = floor(winSize/2);
Scount = 0;
Ncount = 0;



[x,y] = find(HR1(hW+1:h1-hW-1,hW+1:w1-hW-1 ) == 1);
x = x+hW;
y = y+hW;
l1 = length(x)
[a,b] = find(HR2(hW+1:h2-hW-1,hW+1:w2-hW-1 ) == 1);
a = a+hW;
b = b+hW;
l2 = length(b)

SR = [];
NR = [];

for c = 1:l1
    i = x(c);
    j = y(c);
    I1 = HR1(i-hW: i+hW, j - hW: j + hW);
    % NCC
    m1 = mean(I1(:));
    for d = 1:l2
        m = a(d);
        n = b(d);
        % SSD
        I2 = HR2(m-hW: m+hW, n - hW: n + hW);
        ssd = sum(sum((I1-I2).^2));
        if ssd ==0
            Scount = Scount+1;
            SR = [SR;ssd i j m n];

        end
        % NCC
        m2 = mean(I2(:));
        T1 = I1-m1;
        T2 = I2-m2;
        ncc = sum(sum(T1.*T2)) / sqrt(sum(sum(T1.^2))*sum(sum(T2.^2)));
        if ncc > 0.99
            Ncount = Ncount+1;
            NR = [NR;ncc i j m n];
        end
    end
end

SR = sort(SR);
SR = SR(1:ceil(0.5*length(SR)),:);
NR = sort(NR,'descend');
NR = NR(1:ceil(0.5*length(NR)),:);

end

