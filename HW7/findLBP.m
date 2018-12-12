%% ECE 661 2018 Fall Homework 7
% Ye Shi
% shi349@purdue.edu

function H = findLBP(I)
% to find LBP of gray scale image I
[h,w] = size(I);
H = zeros(1,10); % histogram
for i=2:h-1
    for j = 2:w-1
        % find pattern
        n = [i+ cos(2*pi*(0:7)/8);j+sin(2*pi*(0:7)/8)];% 8 neighbours
        p = zeros(1,8); % pattern
        for k = 1:8
            if mod(n(1,k),1)==0 && mod(n(2,k),1)==0 % check for integers
                p(k) = I(n(1,k),n(2,k))>=I(i,j);
            else
                p(k) = findNIValue(n(1,k),n(2,k),I)>=I(i,j);
            end
        end
        % find min binary value
        MSB = 2^8;
        for k = 1:8
            bv = circshift(p,k,2);
            msb = bin2dec(num2str(bv));
            if MSB >= msb
                MSB = msb;
                minbv = bv;
            end
        end
        % find runs
        %         r = xor(minbv(1), minbv(8));
        r=0;
        for k = 1:7
            if xor(minbv(k),minbv(k+1))
                r = r+1;
                if minbv(k+1) == 1
                    tag = k+1;
                end
            end
        end
        
        % encode
        if r<2
            e = sum(minbv);
        elseif r == 2
            e = sum(minbv(tag:end));
        else
            e = 9;
        end
        
        % debug
%         r
%         tag
%         [i,j]
%         p
%         minbv
%         e
%         
        H(e+1) = H(e+1)+1;
    end
end
% nor

end

function i = findNIValue(x,y,I)
% find the non Int coordinate pixel value by d4 interpolation
xt = ceil(x);
xb = floor(x);
yt = ceil(y);
yb = floor(y);

A = I(xb,yb);
B = I(xb,yt);
C = I(xt,yb);
D = I(xt,yt);

dl = y-yb;
dk = x-xb;
i = (1-dk)*(1-dl)*A + (1-dk)*dl*B+ dk*(1-dl)*C +dk*dl*D;

end