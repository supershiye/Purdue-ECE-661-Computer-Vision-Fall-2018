%% ECE 661 2018 Fall Homework 8
% Ye Shi
% shi349@purdue.edu

function [mu,nu] = reproj(fixed, target, LMK)
% reproject target image to fixed image by LM calibration
Hf = LMK*[fixed.LMR(:,1:2) fixed.LMt];
Ht = LMK*[target.LMR(:,1:2) target.LMt];
H = Hf*pinv(Ht);
est_corners  = H*[reshape(extractfield(target.corner,'corner'),2,80);ones(1,80)];
est_corners = [est_corners(1:2,:)./est_corners(end,:)]';
fixed_corners = reshape(extractfield(fixed.corner,'corner'),2,80)';
err = vecnorm(fixed_corners-est_corners,2,2);
f = figure;
imshow(fixed.data)
hold on
scatter(fixed_corners(:,1),fixed_corners(:,2),60,'x','MarkerEdgeColor','r','MarkerFaceColor','r');
hold on
scatter(est_corners(:,1),est_corners(:,2),60,'x','MarkerEdgeColor','g','MarkerFaceColor','g');
hold on
for j = 1:80
    text(fixed.corner(j).corner(1),fixed.corner(j).corner(2),int2str(fixed.corner(j).label),'Color','yellow','FontSize',7);
    hold on
end
hold off;
img = getframe();
imwrite(img.cdata,[target.name(1:end-4),'To',fixed.name(1:end-4),'.png'])
close(f)
mu = mean(err);
nu =var(err);
end


