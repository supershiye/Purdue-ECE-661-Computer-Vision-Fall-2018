%% ECE 661 2018 Fall Homework 4
% Ye Shi
% shi 349@purdue.edu

function pltPairs1(C1,C2,HR1,HR2,pairs,filename)
% This function is to generate the final image of Harris Corner

[h,w,c] = size(C1);
fig = figure;
imshow([C1,C2]);
hold on
[x1,y1]= find(HR1);
plot(y1,x1,'x')
hold on
[x2,y2]= find(HR2);
plot(y2+w,x2,'o')
hold on
set(gca,'position',[0 0 1 1],'units','normalized')
x1 = pairs(:,1);
y1 = pairs(:,2);
x2 = pairs(:,3);
y2 = pairs(:,4)+w;

for i = 1:size(pairs,1)
    line([y1(i),y2(i)],[x1(i),x2(i)],'Color','g','LineStyle','-');
    hold on
end
hold off;
saveas(fig,[filename,'.png'])
end