% get min, max, mean activity of a layer during specified trial

function [minA, maxA, meanA] = getMinMaxMean (As, layer, trial)

idxTrial = find(As(:,1)==trial);
tidx = As(idxTrial,2); 
data = []; 

for t = 1:length(tidx)
    data = [data; layer(tidx(t), :, idxTrial(t))]; 
end 

minA = min(min(data)); 
meanA = mean(mean(data)); 
maxA = max(max(data)); 




