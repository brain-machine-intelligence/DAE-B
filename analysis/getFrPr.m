% to reproduce 2023: pause prevalence vs fr 
% get pause rate, firing rate and corrected firing rate

function [fr, pr, frCorrected] = getFrPr (As, GPes, trialt, thr)

data = [];

idxTrial = find(As(:,1)==trialt);
tidx = As(idxTrial,2);

for t = 1:length(tidx)
    data = [data; GPes(tidx(t), :, idxTrial(t))];
end

fr = mean(data); 

pdata = (data < thr); 
pr = mean(pdata); 

% find no pause periods to compute corrected fr
cdata = 1-pdata; 
cdata(cdata==0) = NaN;
frCorrected = cdata .* data; 

% in case a cell is always pausing
findNaNcol = sum(1-pdata); 
findNaNcol = find(findNaNcol==0); 
frCorrected(:,findNaNcol) = 0; 

frCorrected = mean(frCorrected, 'omitnan');

