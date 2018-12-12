%% ECE 661 2018 Fall Homework 6
% Ye Shi
% shi349@purdue.edu

function mask = TextureSeg(Img,filename)
% Texture based segmentation
N = [3,5,7]; % window sizes
[h,w,c] = size(Img);
if c ==3
GrayI = double(rgb2gray(Img));
end
VarI = zeros(h,w,c);

for n = 1:3
    % Find the variance of each window and normalize it to  [0,255] for
    % Otsu
    VarI(:,:,n) = normalize( stdfilt(GrayI, true(N(n))).^2, 'range').*255;
    imwrite(uint8(VarI(:,:,n)),[filename,'_n',num2str(N(n)),'.png']);
end
mask =  Otsu(VarI,filename);
end