% compute signal to noise ratio
% signal = contrast between leftNP vs mean others 
% noise = mean std of each options 
% GPe = GPe activity at stage 1 during trial of interest; for 100 simulations

% snrType 1 = mean signal^2 / mean var  (conventional def of SNR)
% snrType 2 = mean signal / mean std

function [s, n, snr] = getSNR (GPe, snrType)

temp = GPe';

if snrType == 1
    s = mean((temp(1,:) - mean(temp(2:10,:))).^2);
    n = mean(var(GPe));
    snr = s/n; 

elseif snrType == 2 
    s = mean(temp(1,:) - mean(temp(2:10,:))); 
    n = mean(std(GPe));
    snr = s/n;
end

