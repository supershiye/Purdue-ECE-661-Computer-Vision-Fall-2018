%% ECE 661 2018 Fall Homework 6
% Ye Shi
% shi349@purdue.edu

function FinalPlot(Img,Method,filename)
% Plot the foreground, background and contour images

if strcmp(Method, 'Otsu')
    
    filename = [filename,'_Otsu'];
    Mask =  Otsu(Img,filename);
elseif strcmp(Method,'TBS')
    
    filename = [filename,'_TBS'];
    Mask =  TextureSeg(Img,filename);
end
SegPlot(Img,Mask,filename)
end