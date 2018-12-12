%% ECE 661 2018 Fall Homework 9
% Ye Shi
% shi349@purdue.edu

function [H1,H2] = rectify(P1,P2,e1,e2,I1,I2,points1,points2)
% fucntion to find H and H'
[h,w]=size(I1);
%% Find H2
e2=e2/e2(end);
% rotation angle
theta=atan(-(e2(2)-h/2)/(e2(1)-w/2));
f=cos(theta)*(e2(1)-w/2)-sin(theta)*(e2(2)-h/2);
% rotation matrix
R=[cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0; 0 0 1];
% Translate origin to center
T=[1 0 -w/2;0 1 -h/2;0 0 1];
% Translate baseline to infinity
G=[1 0 0;0 1 0;-1/f 0 1];
H2=G*R*T;
% Construct T2 to send origin back to original center
center=[w/2 h/2 1]';
newCen=H2*center;
newCen=newCen/newCen(end);
T2=[1 0 w/2-newCen(1);0 1 h/2-newCen(2);0 0 1];
H2=T2*H2;
H2 = H2./H2(end);

%% Find H1
if 1
    e1=e1/e1(end);
    % rotation angle
    theta=atan(-(e1(2)-h/2)/(e1(1)-w/2));
    f=cos(theta)*(e1(1)-w/2)-sin(theta)*(e1(2)-h/2);
    % rotation matrix
    R=[cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0; 0 0 1];
    % Translate origin to center
    % T=[1 0 -w/2;0 1 -h/2;0 0 1];
    T=[1 0 -w/2;0 1 -h/2;0 0 1];
    % Translate baseline to infinity
    G=[1 0 0;0 1 0;-1/f 0 1];
    H1=G*R*T;
    % Construct T2 to send origin back to original center
    center=[w/2 h/2 1]';
    newCen=H1*center;
    newCen=newCen/newCen(end);
    T2=[1 0 w/2-newCen(1);0 1 h/2-newCen(2);0 0 1];
    H1=T2*H1;
    H1 = H1./H1(end);
end

%% Method from past solution doesn't work
if 1
    ptsNum = size(points1,1);
    % M=P2*pinv(P1);
    % H0=H2*M;
    H0 = H1;
    % Construct for LSE
    
    A = H0* [points1,ones(ptsNum,1)]';
    A =( A./A(end,:))';
    
    b = H2* [points2,ones(ptsNum,1)]';
    % b =( b(1,:)./b(end,:))';
    b =( b(2,:)./b(end,:))';
    
    p=pinv(A)*b;
    % HA=[p(1) p(2) p(3); 0 1 0; 0 0 1];
    HA=[1 0 0; p'; 0 0 1];
    H1=HA*H0;
    % % Recenterlize the H1
    newCen=H1*center;
    newCen=newCen./newCen(end);
    T1=[1 0 w/2-newCen(1);0 1 h/2-newCen(2);0 0 1];
    H1=T1*H1;
    H1 = H1./H1(end);
end



end