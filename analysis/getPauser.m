% give number pausers 
% pause is defined as activity < thr
% pauser is defined as pause rate > pauserThr
% Layer = GPes or GPis

function [pauserR] = getPauser (layer, As, trials, thr, trial, pauserThr, para); 

actionN = para(4); % number of actions 

idxTrial = find(As(:,1)==trial);
tidx = As(idxTrial,2); 
data = []; 

for t = 1:length(tidx)
    data = [data; layer(tidx(t), :, idxTrial(t))]; 
end 

pauseR = (data < thr); 
pauseR = mean(pauseR); 

pauserR = length(find(pauseR > pauserThr)) / actionN; 




