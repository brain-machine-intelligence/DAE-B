% compute GPe activity before GPe-STN loop
% input Qm here is not Qms. but Qm for trial of interest 

function [preGPe] = getPreGPeActivity (Qm, para3, para4)

pvf = para3(1); 
gpef = para3(2);
STNc = para4(2); 

Cortex = 0; 
pv = 0; 
STN = STNc + Cortex - pv*pvf; 
STN = neuronActFtn(STN,1); 

preGPe = STN * gpef - Qm; 
preGPe = neuronActFtn(preGPe,1); 