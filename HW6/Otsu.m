%% ECE 661 2018 Fall Homework 6
% Ye Shi
% shi349@purdue.edu

function Mask =  Otsu(Img,filename)
% Otsu algorithm
[w,h,c] = size(Img);
K = zeros(1,c);
Masks = cell(1,3); % Foreground Mask
Ch = ['R','G','B'];
for C = 1:c
    
    P = zeros(1,256); % Probability density for gray lelvel
    D = zeros(1,256); % Between class variance
    I = Img(:,:,C); % Current gray scale image
    N = sum(I ~=0,'all'); % total pixels
    for k = 0:255
        P(k+1) = sum(I==k & I ~=0,'all')/N;
    end
    for k = 0:255
        W0 = sum(P(1:k));
        W1 = sum(P(k+1:256));
        U0 = sum(I(find(I<=k)),'all')/sum(I<=k & I ~=0,'all');
        U1 = sum(I(find(I>k)),'all')/sum(I>k,'all');
        D(k+1) = W0*W1*(U0 - U1)^2;
    end
    [~,K(C)] = max(D);
    Masks{C} = I < K(C);
    SegPlot(Img,Masks{C},[filename,Ch(C)]);
    
end

% Mask = ones(w,h);
% 
% 
% for C = 1:c
%     Mask  = Mask & Masks{C};
% end
Mask = Masks{1} &  Masks{2} &Masks{3};
if 1
    Mask = double(Mask);
    % Reduce some noise
    SE = strel('ball',10,10);
    Mask = imdilate(Mask,SE);
%     Mask = imdilate(Mask,SE);
%     Mask = imerode(Mask,SE);
    Mask = imerode(Mask,SE);
    Mask = Mask>0;
end

end
