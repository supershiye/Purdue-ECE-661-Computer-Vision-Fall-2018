%% ECE 661 2018 Fall Homework 5
% Ye Shi
% shi349@purdue.edu

function H = LMfindH(pairs)
pairs = double(pairs);
H0 = 1*ones(1,9);
fun = @(H) myfun(H,pairs);
options.Algorithm = 'levenberg-marquardt';
H = lsqnonlin(fun,H0,[],[],options);
H = [H(1:3);H(4:6);H(7:9)];

end

function err = myfun(H,pairs)
% This is the function for non linear least square optimzation
H = [H(1:3);H(4:6);H(7:9)];
n = size(pairs,1);
xdata = [pairs(:,1:2),ones(n,1)]';
ydata = [pairs(:,3:4),ones(n,1)]';
estydata = H*xdata;
estydata = estydata./estydata(end,:);
err = ydata - estydata;
end
