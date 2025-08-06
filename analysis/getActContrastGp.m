% get activity contrast between correct response and other actions (2:10) in
% GPe or GPi 
% GPs is either GPes or GPis
% consider only states 1-10


function [contg] = getActContrastGp(GPs, t, action)

contg = []; 

othera = setdiff([1:10], [action]); 

contg = GPs(1:10, action, t) - mean(GPs(1:10, othera, t)')';
contg = -sum(contg);


