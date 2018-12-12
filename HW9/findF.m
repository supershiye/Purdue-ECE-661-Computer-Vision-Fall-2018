%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function F = findF(points1,points2,Nflag)
% This function is used to find the fundemental matrix
if nargin <3
    Nflag = 0;
end

l = length(points1);
if l <8
    error("Please input at least 8 pairs of points!");
end

% Normalize
if Nflag
    T1 = findT(points1);
    T2 = findT(points2);
    points1 = T1*[points1 ones(l,1)]';
    points1 = [points1(1:2,:)./points1(end,:)]';
    points2 = T2*[points2 ones(l,1)]';
    points2 = [points2(1:2,:)./points2(end,:)]';
end

A = zeros(l,9);
for i = 1:l
    A(i,:) = [points1(i,1)*points2(i,1) ,
        points1(i,2)*points2(i,1) ,
        points2(i,1) ,
        points1(i,1)*points2(i,2) ,
        points1(i,2)*points2(i,2) ,
        points2(i,2),
        points1(i,1) ,
        points1(i,2) ,
        1];
end
[~,~,V] = svd(A);
F = reshape(V(:,end),3,3)';
% Reduce rank(F) to 2
if rank(F) == 3
[U,S,V] = svd(F);
S(end) = 0;
F = U*S*V';
end
if Nflag
    F = T2'*F*T1;
end
F = F./F(end);
end

