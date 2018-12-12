%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function [F,P1,e1,P2,e2,X] = refineF(F0,points1,points2)
% Refine F by LM
[P1,P20] = findP(F0);
p20 = P20(:);
X0 = findX(P1,P20,points1,points2);
xl = size(X0,1);
x0 = X0(:);
p0 = [p20;x0];
options.Algorithm = 'levenberg-marquardt';
options.FunctionTolerance =1e-8;
% options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt'...
% ,'TolX',0.00000000001,'TolFun',0.00000000001);
p = lsqnonlin(@PXcost,p0,[],[],options,points1,points2);
p2 = p(1:12);
P2 = reshape(p2,3,4);
P2 = P2./P2(end);
x = p(13:end);
X =reshape(x,xl,3);
e2 = P2(:,end);
e2x= [0 -e2(3) e2(2);e2(3) 0 -e2(1);-e2(2) e2(1) 0];
% F = reshape(f,3,3);
F = e2x*P2*pinv(P1);
F = F./F(end);
e1 = null(F);
end

function err = PXcost(p,points1,points2)
% Cost function for refine P and X
nt = size(points1,1);
p2 = p(1:12);
P2 = reshape(p2,3,4);
x = p(13:end);
X =reshape(x,nt,3);
P1 = [eye(3),zeros(3,1)];
P2 = reshape(p2,3,4);
estPoints1 = P1*[X';ones(1,nt)];
estPoints1 = estPoints1(1:2,:)./ estPoints1(end,:);
estPoints2 = P2*[X';ones(1,nt)];
estPoints2 = estPoints2(1:2,:)./ estPoints2(end,:);
err  = sum(vecnorm(estPoints2 - points2')) + ...
    sum(vecnorm(estPoints1 - points1'));
end
