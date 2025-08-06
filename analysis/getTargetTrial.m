% find the first trial of the target trial type since z-th trial 
% trialType = 1~3

function [newz] = getTargetTrial (trials, z, trialType)

targetTs = find(trials(:,5)==trialType); 
newz = min(find(targetTs > z)); 
newz = targetTs(newz); 
