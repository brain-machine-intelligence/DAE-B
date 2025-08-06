% get firing rate during cue and outcome
% get baselinei firing rate and baseline pause rate 

function [frateB, prateB, frateCue, frateOut] = getBaseNCue (As, layer, trial, thr, trialType)

% find cue t
cuet = 11; 
outt = 12;

% get trial activity data
idxTrial = find(As(:,1)==trial);
tidx = As(idxTrial,2); 
data = []; 
for t = 1:length(tidx)
    data = [data; layer(tidx(t), :, idxTrial(t))]; 
end 
gpe = data;

% baseline GPe firing rate
frateB = mean(gpe(1:10,:));

% baseline GPe pause rate
pauseN = gpe(1:10,:) < thr;
prateB = mean(pauseN); 

frateCue = gpe(cuet,:);
frateOut = gpe(outt,:);

