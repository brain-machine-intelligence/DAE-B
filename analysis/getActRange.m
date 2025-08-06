% get max activity in the given layer during the specified trial 


function [actr] = getActRange (Layer, trial)

temp = Layer(:,:, trial);
actr = max(max(temp));


