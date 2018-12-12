%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

function img = projectH(img1,img2,H,mono,filename)
% This function can project img1 to img2 by H, x2 = H*x1
if nargin <4
    filename = datetime('today');
end
% Mono switch
% mono  = 0

[h1,w1,c1] = size(img1);
[h2,w2,c2] = size(img2);
% H = H'
% define new img size
points = [0 0 1; h1 0 1; 0 w1 1; h1 w1 1]';
newpoints = H*points;
newpoints = newpoints./newpoints(end,:);
minh1 = floor(min(newpoints(1,:)));
maxh1 = ceil(max(newpoints(1,:)));
minw1 = floor(min(newpoints(2,:)));
maxw1 = ceil(max(newpoints(2,:)));

minh = min([minh1,0]);
maxh = max([maxh1,h2]);
minw = min([minw1,0]);
maxw = max([maxw1,w2]);

newh = ceil(maxh - minh);
neww = ceil(maxw-minw);

img = zeros(newh,neww,c1);


for x = 1:h2
    for y = 1:w2
        if mono == 1
            img(x-minh,y-minw,1)= img2(x,y,1);
        else
            img(x-minh,y-minw,:)= img2(x,y,:);
        end
        
    end
end

invH = H^-1;

for x = 1:newh
    for y = 1:neww
        Loc1 = invH*[x+minh,y+minw,1]';
        Loc1 = round(Loc1./Loc1(end));
        if Loc1(1) > 0 && Loc1(1)<= h1 && Loc1(2) > 0 && Loc1(2)<= w1
            if mono == 1
                img(x,y,2) = img1(Loc1(1),Loc1(2),2);
            else
                if sum(img1(Loc1(1),Loc1(2),:)) ~= 0
                    img(x,y,:) = img1(Loc1(1),Loc1(2),:);
                end
            end
        end
    end
end

if mono == 1
    filename = [filename,'M'];
end


img = uint8(img);
fig = figure;
set(gca,'position',[0 0 1 1],'units','normalized')
imshow(img)
saveas(fig,[filename,'.png'])
end