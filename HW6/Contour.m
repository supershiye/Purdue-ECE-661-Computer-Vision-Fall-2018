%% ECE 661 2018 Fall Homework 6
% Ye Shi
% shi349@purdue.edu

function contour = Contour( Mask )
% Contour Extraction
[m,n] = size(Mask);
contour = zeros(m,n);
N = 3; % 3x3 window size
halfWin = floor((N-1)/2);
Mask = padarray(Mask,[(N-1)/2 (N-1)/2]);
for i = 1:m
    for j = 1:n
        if(Mask(halfWin+i,halfWin+j) == 0)
            contour(i,j) = 0;
        else
            window = Mask(halfWin+(i-halfWin):halfWin+(i+halfWin),halfWin+(j-halfWin):halfWin+(j+halfWin));
            if(sum(window(:)) ~= N*N) % take out the inner part
                contour(i,j) = 1;
            end
        end
    end
end
end