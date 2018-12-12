%% ECE 661 2018 Fall Homework 8
% Ye Shi
% shi349@purdue.edu

function err = dgeom(p,world,dataset)
% Cost function for the LM

num = numel(dataset);
ax = p(1);
s = p(2);
x0 = p(3);
ay = p(4);
y0 = p(5);
% Intrinsic calibration matrix
K = [ax s x0;
    0 ay y0;
    0 0 1];
% Radial distortion
if  p(end) ==1
    % Parameters for radial distortion
    k1 = p(6);
    k2 = p(7);
end

err = [];
for k = 1:num
    if ~isempty(dataset(k).H)
        
        R= rotationVectorToMatrix(p((k-1)*6+8:(k-1)*6+10));
        t = p(k*6+7-2:k*6+7)';
        est_corners = K*[R t] * [world.corner zeros(80,1) ones(80,1)]';
        est_corners = est_corners./est_corners(3,:);
        % Radial distortion
        if  p(end) ==1
            r = sum([est_corners(1,:)-240;est_corners(2,:)-320].^2,1);
            xrad = est_corners(1,:) + (est_corners(1,:)-240).*(k1.*r+k2.*r.^2);
            yrad = est_corners(2,:) + (est_corners(2,:)-320).*(k1.*r+k2.*r.^2);
            est_corners = [xrad;yrad];
        end
        real_corners = reshape(extractfield(dataset(k).corner,'corner'),2,80);
        err = [err est_corners(1:2,:)-real_corners];
    end
end

end
