% get number of instrumental behavior during the specified trial

function [nInst] = getInstBehav (As, trial); 

n = find(As(:,1)==trial); % time points in the selected trial 

nInst = 0; 
actions = As(n,3); 
 
for a = 1:3 % lnp, rnp, me
    nInst = nInst + length(find(actions==a)); 
end 

nInst = nInst/length(n); 


