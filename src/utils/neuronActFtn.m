% bound unit activity to 0~1

function [y] = neuronActFtn (x, otype); 
 
y = x; 

y(x>1) = 1; 

if otype == 1    
    y(x<0) = 0;
end 



