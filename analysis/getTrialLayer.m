% get unit activity in GPe, GPi, Qm, Qp during the specified trials 

function [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, trial); 

GPe = []; GPi = []; Qm = []; Qp = []; 

n = find (As(:,1)==trial);
s = As(n,2); 

for i = 1:length(n)
    GPe = [GPe; GPes(s(i),:,n(i))]; 
    GPi = [GPi; GPis(s(i),:,n(i))]; 
    Qp = [Qp; Qps(s(i),:,n(i))]; 
    Qm = [Qm; Qms(s(i),:,n(i))]; 
end 