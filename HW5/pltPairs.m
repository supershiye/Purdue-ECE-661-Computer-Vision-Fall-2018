%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi 349@purdue.edu

function pltPairs(C1,C2,pairs, pairsIdx,filename)
% This function is to generate the final image of SURF matching
% also indicates inliners and outliners

[h,w,c] = size(C1);
fig = figure;
imshow([C1,C2]);
hold on
V1 = pairs(:,[2,1]);
V2 = pairs(:,[4,3]);
plot(V1(:,1),V1(:,2),'x');
hold on
plot(V2(:,1)+w,V2(:,2),'o');
hold on
set(gca,'position',[0 0 1 1],'units','normalized')
x1 = pairs(:,1);
y1 = pairs(:,2);
x2 = pairs(:,3);
y2 = pairs(:,4)+w;

for i = 1:size(pairs,1)
    if ismember(i, pairsIdx)
    line([y1(i),y2(i)],[x1(i),x2(i)],'Color','g','LineStyle','-');
    hold on
    else
            line([y1(i),y2(i)],[x1(i),x2(i)],'Color','b','LineStyle','-');
    hold on
    end
end
hold off;
saveas(fig,[filename,'.png'])
end