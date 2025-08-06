% get CR rate to reproduce 2023 fig 1b. 
% 1 lick, 2 blink, 0 non_inst

function [CRrate] = getRNAcrRate (As, trial, crA)

CRrate = nan(1,3);
idx = find(As(:,1)==trial);
Adata = As(idx,3);

if crA > 0     
    CRrate(1) = length(find(Adata(1:10)==crA))/10;
    CRrate(2) = length(find(Adata(11)==crA));
    CRrate(3) = length(find(Adata(12)==crA));

elseif crA==0 % noninst
    CRrate(1) = length(find(Adata(1:10)>2))/10/8;
    CRrate(2) = length(find(Adata(11)>2))/8;
    CRrate(3) = length(find(Adata(12)>2))/8;
end


