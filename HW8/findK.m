%% ECE 661 2018 Fall Homework 8
% Ye Shi
% shi349@purdue.edu

function K = findK(HvecSet)
% Find the intrinsic camer matrix K
% HvecSet is homography vector [h11, h21,h31 , ... , h33; 
%h11, h21,h31 , ... , h33; ...]
[m,n] = size(HvecSet);
if n ~=9
    error('Wrong matrix demension!');
elseif m <= 2
    error('Not enough homographies!');
end

% construct V matrix
Hcon = @(H) reshape(H,3,3);
Vrow = @(H,i,j) [H(1,i)*H(1,j),...
    H(1,i)*H(2,j)+H(2,i)*H(1,j),...
    H(2,i)*H(2,j),...
    H(3,i)*H(1,j)+H(1,i)*H(3,j) ,...
    H(3,i)*H(2,j)+H(2,i)*H(3,j),...
    H(3,i)*H(3,j)];

V = zeros(2*m,6);
for k = 0:m-1
    H = Hcon(HvecSet(k+1,:));
    V(2*k+1:2*k+2,:) = [Vrow(H,1,2);
        Vrow(H,1,1) - Vrow(H,2,2)];
end

% SVD V to find the parameters in K
[~,~,T] = svd(V);
b = T(:,6); %B11 B12 B22 B13 B23 B33

y0 = (b(2)*b(4)-b(1)*b(5))/(b(1)*b(3)-b(2)^2);
l = b(6)-(b(4)^2+y0*(b(2)*b(4)-b(1)*b(5)))/b(1);
ax = sqrt(l/b(1));
ay = sqrt(l*b(1)/(b(1)*b(3)-b(2)^2));
s = -b(2)*ax^2*ay/l;
x0 = s*y0/ay-b(4)*ax^2/l;
K = [ax s x0; 0 ay y0; 0 0 1];
end
