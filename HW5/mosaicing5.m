%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

function img = mosaicing5(imgset,H,filename)
% imgset is a 5-image cell
% H is a 4-pairwise-homography cell 
if nargin <3
    filename = datetime('today');
end
% Mono switch
mono = 1

% All images are the same size
[h1,w1,c1] = size(imgset{1});

% define new img size
points = [0 0 1; h1 0 1; 0 w1 1; h1 w1 1]';
newpoints1 = H{1}*H{2}*points;
newpoints1 = newpoints1./newpoints1(end,:);
minh1 = floor(min(newpoints1(1,:)));
maxh1 = ceil(max(newpoints1(1,:)));
minw1 = floor(min(newpoints1(2,:)));
maxw1 = ceil(max(newpoints1(2,:)));

newpoints2 = H{2}*points;
newpoints2 = newpoints2./newpoints2(end,:);
minh2 = floor(min(newpoints2(1,:)));
maxh2 = ceil(max(newpoints2(1,:)));
minw2 = floor(min(newpoints2(2,:)));
maxw2 = ceil(max(newpoints2(2,:)));

newpoints3 = H{3}^-1 * points;
newpoints3 = newpoints3./newpoints3(end,:);
minh3 = floor(min(newpoints3(1,:)));
maxh3 = ceil(max(newpoints3(1,:)));
minw3 = floor(min(newpoints3(2,:)));
maxw3 = ceil(max(newpoints3(2,:)));

newpoints4 = H{3}^-1 * H{4}^-1 *points;
newpoints4 = newpoints4./newpoints4(end,:);
minh4 = floor(min(newpoints4(1,:)));
maxh4 = ceil(max(newpoints4(1,:)));
minw4 = floor(min(newpoints4(2,:)));
maxw4 = ceil(max(newpoints4(2,:)));

% Find the extrima of all projections
minh = min([minh1,minh2,minh3,minh4,0]);
maxh = max([maxh1,maxh2,maxh3,maxh4,h1]);
minw = min([minw1,minw2,minw3,minw4,0]);
maxw = max([maxw1,maxw2,maxw3,maxw4,w1]);


newh = ceil(maxh - minh);
neww = ceil(maxw-minw);

img = zeros(newh,neww,c1);

% middle image is the base
for x = 1:h1
    for y = 1:w1
        if mono == 1
            img(x-minh,y-minw,1)= imgset{3}(x,y,1);
        else
            img(x-minh,y-minw,:)= imgset{3}(x,y,:);
        end
        
    end
end

invH = (H{1}*H{2})^-1;

% Left image 
for x = 1:newh
    for y = 1:neww
        Loc1 = invH*[x+minh,y+minw,1]';
        Loc1 = round(Loc1./Loc1(end));
        if Loc1(1) > 0 && Loc1(1)<= h1 && Loc1(2) > 0 && Loc1(2)<= w1
            if mono == 1
                img(x,y,2) = imgset{1}(Loc1(1),Loc1(2),2);
            else
                if sum(imgset{1}(Loc1(1),Loc1(2),:)) ~= 0
                    img(x,y,:) = imgset{1}(Loc1(1),Loc1(2),:);
                end
            end
        end
    end
end


invH = H{2}^-1;
% Left-middle image
for x = 1:newh
    for y = 1:neww
        Loc1 = invH*[x+minh,y+minw,1]';
        Loc1 = round(Loc1./Loc1(end));
        if Loc1(1) > 0 && Loc1(1)<= h1 && Loc1(2) > 0 && Loc1(2)<= w1
            if mono == 1
                img(x,y,3) = imgset{2}(Loc1(1),Loc1(2),3);
            else
                if sum(imgset{2}(Loc1(1),Loc1(2),:)) ~= 0
                    img(x,y,:) = imgset{2}(Loc1(1),Loc1(2),:);
                end
            end
        end
    end
end



invH = H{3};
% Right-middle image
for x = 1:newh
    for y = 1:neww
        Loc1 = invH*[x+minh,y+minw,1]';
        Loc1 = round(Loc1./Loc1(end));
        if Loc1(1) > 0 && Loc1(1)<= h1 && Loc1(2) > 0 && Loc1(2)<= w1
            if mono == 1
                img(x,y,3) = imgset{4}(Loc1(1),Loc1(2),3);
            else
                if sum(imgset{4}(Loc1(1),Loc1(2),:)) ~= 0
                    img(x,y,:) = imgset{4}(Loc1(1),Loc1(2),:);
                end
            end
        end
    end
end

invH = H{4}*H{3};
% Right-middle image
for x = 1:newh
    for y = 1:neww
        Loc1 = invH*[x+minh,y+minw,1]';
        Loc1 = round(Loc1./Loc1(end));
        if Loc1(1) > 0 && Loc1(1)<= h1 && Loc1(2) > 0 && Loc1(2)<= w1
            if mono == 1
                img(x,y,2) = imgset{5}(Loc1(1),Loc1(2),2);
            else
                if sum(imgset{5}(Loc1(1),Loc1(2),:)) ~= 0
                    img(x,y,:) = imgset{5}(Loc1(1),Loc1(2),:);
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