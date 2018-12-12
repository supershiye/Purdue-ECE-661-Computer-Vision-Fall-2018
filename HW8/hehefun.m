LSEmean = extractfield(dataset,'estmean');
LSEvar = extractfield(dataset,'estvar');
LMmean = extractfield(dataset,'LMestmean');
LMvar = extractfield(dataset,'LMestvar');
LMrmean = extractfield(dataset,'LMrestmean');
LMrvar = extractfield(dataset,'LMestvar');

filLM = find(LSEmean>LMmean & LSEvar>LMvar)
dataset(filLM).name

filLMr = find(LSEmean~=LMrmean)