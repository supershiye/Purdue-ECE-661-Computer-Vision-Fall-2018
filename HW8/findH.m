%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

function H = findH(pairs)
% This function can find homography by SVD
% pairs are m (m>5) pairs of corresponding points by (x1,y1,x2,y2)
m = size(pairs,1);
if m < 5
    disp("No necessary number of pairs (m<5)");
    return
end
disp([num2str(m),' pairs points are used to find the homography.']);
A = zeros(m*2,9);
% Construct A
for i = 0:m-1
    A(i*2+1:i*2+2,:) = [0 0 0 -pairs(i+1,1) -pairs(i+1,2) -1 pairs(i+1,4)*pairs(i+1,1) pairs(i+1,4)*pairs(i+1,2) pairs(i+1,4);
        pairs(i+1,1) pairs(i+1,2) 1 0 0 0 -pairs(i+1,1)*pairs(i+1,3) -pairs(i+1,3)*pairs(i+1,2) -pairs(i+1,3)];
end
if rank(A)< 9
    disp("Warning: Rank(A) is less than 9!");
end
[~,~,V] = svd(A); % V is order by the descending order of S
H = V(:,end); % H is the vector with smallest S
H = [H(1:3)';H(4:6)';H(7:9)'];
end