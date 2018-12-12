function runHCD4Scales(CP1a,CP1b,Name)
GP1a = rgb2gray(CP1a);
GP1b = rgb2gray(CP1b);

parfor scale = 1:4

HR1a{scale} = HCD(GP1a,scale);
HR1b{scale} = HCD(GP1b,scale);

[SR{scale},NR{scale}] = HCmatch(HR1a{scale},HR1b{scale});
pltPairs(CP1a,CP1b,SR{scale}(:,2:5),[Name,num2str(scale),'S'])
pltPairs(CP1a,CP1b,NR{scale}(:,2:5),[Name,num2str(scale),'N'])
end


