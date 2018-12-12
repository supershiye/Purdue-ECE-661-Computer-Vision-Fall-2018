%% ECE 661 2018 Fall Homework 8
% Ye Shi
% shi349@purdue.edu

function C = findCorner(I,filename)
% To find the cornor in a grayscale image I
if nargin <2
    filename = datestr(datetime(),30)
end
[h,w] = size(I);

E = edge(I,'canny',0.75); % canny edge detector with treshold 0.7

f = figure;
% hough transfom
[H,T,R] = hough(E,'RhoResolution',0.5);
MaxlineNum = 18;
lineNum = 0;
hpfactor = 0.31;
while lineNum <18
    hpfactor = hpfactor-0.01;
    P = houghpeaks(H,MaxlineNum,'Threshold',hpfactor*max(H(:)));
    lines = houghlines(E,T,R,P,'FillGap',300,'MinLength',70);
    lineNum = length(lines);
end


% separete lines by 2 orthogonal directions

LinesHC = zeros(lineNum,3);
for i = 1:lineNum
    l = LineHC(lines(i));
    LinesHC(i,:) =l;
end
LinesHC1 = sortrows(LinesHC);
LinesHC1 = LinesHC1(1:8,:);
LinesHC2 = sortrows(LinesHC,2);
LinesHC2 = LinesHC2(1:10,:);

% Plot the lines
for i = 1:8
    p1 = cross(LinesHC1(i,:),[0 1 0]);
    p2 = cross(LinesHC1(i,:),[0 1 -h]);
    xy = [p1(1:2)./p1(end) ; p2(1:2)./p2(end)];
    plot(xy(:,1),xy(:,2),'LineWidth',.5,'Color','green');
    hold on;
end
for i = 1:10
    p1 = cross(LinesHC2(i,:),[1 0 -w]);
    p2 = cross(LinesHC2(i,:),[1 0 0]);
    xy = [p1(1:2)./p1(end) ; p2(1:2)./p2(end)];
    plot(xy(:,1),xy(:,2),'LineWidth',.5,'Color','blue');
    hold on;
end

% find insection points
pnum = 0;
nl1 = length(LinesHC1);
nl2 = length(LinesHC2);
for i = 1:nl2
    for j = 1:nl1
        pnum = pnum+1;
        point = cross(LinesHC1(j,:),LinesHC2(i,:));
        point = point./point(end);
        point = point(1:2);
        % trim outrange points
        if sum(point>[1 1])==2  && sum(point<=[w h])==2
            points(pnum,:) = point;
        else
            pnum = pnum-1;
        end
    end
end
points = points(1:pnum,:);

% output and plot corners and label
cnum = min(80, length(points)); % fixed
C = struct('corner',[],'label',[]);

for i = 1:cnum
    C(i).corner = points(i,:);
    C(i).label = i;
    plot(points(i,1),points(i,2),'x','LineWidth',1,'Color','red');
    hold on
    text(points(i,1),points(i,2),int2str(C(i).label),'Color','yellow','FontSize',7);
    hold on
end
if cnum ==80
    img = getframe();
    imwrite(img.cdata,[filename,'_corners.png']);
    close(f)
    f = figure;
    imshow(E);
    hold off;
    img = getframe();
    imwrite(img.cdata,[filename,'_edge.png']);
    close(f)
else
    close(f)
end

end

function l = LineHC(line)
% transfer lines to HC
p1a = [line.point1 1];
p1b = [line.point2 1];
l = cross(p1a,p1b);
if l(end) == 0
    l = [];
else
    l = l./l(end);
end
end
