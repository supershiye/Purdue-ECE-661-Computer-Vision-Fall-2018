function points=getpoints(CI)
figure
imshow(CI)
[y x] = getpts;
points = round([y x]);
end