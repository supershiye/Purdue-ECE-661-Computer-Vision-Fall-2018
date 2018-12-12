%% ECE 661 2018 Fall Homework 6
% Ye Shi
% shi349@purdue.edu

function SegPlot(Img,Mask,filename)
% Plot the foreground, background and contour images
contour = Contour( Mask );
[h,w,c] = size(Img);
Fimg = zeros(h,w,c);
Bimg = zeros(h,w,c);
Cimg = Img;
for i = 1:h
    for j = 1:w
        if Mask(i,j) == 1
%             for C = 1:c
%                 Fimg(i,j,C) = Img(i,j,C);
%             end
            Fimg(i,j,:) = Img(i,j,:);
        else
%             for C = 1:c
%                 Bimg(i,j,C) = Img(i,j,C);
%             end
            
                Bimg(i,j,:) = Img(i,j,:);
        end
        if contour(i,j,:) == 1
            Cimg(i,j,2) = 255;
            Cimg(i,j,1) = 0;
            Cimg(i,j,3) = 0;
        end
    end
end
imwrite(uint8(Fimg),[filename,'_foreground.png']);
imwrite(uint8(Bimg),[filename,'_background.png']);
imwrite(uint8(Cimg),[filename,'_contour.png']);