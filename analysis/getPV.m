% get pv during NP, ME and NonInst

function [pvday] = getPV(PVs, As, sessNs, sessTs, correctA); 

pvnp = NaN(sessNs(end), 19); % NP
pvme = NaN(sessNs(end), 19); % ME
pvother = NaN(sessNs(end), 19); % NonInst

for i = 1:sessTs(end)
    a = As(i,3); 
    
    if a==correctA
        pvnp(As(i,1), As(i,2)) = PVs(As(i,1), As(i,2)); 

    elseif a==3 % me
        pvme(As(i,1), As(i,2)) = PVs(As(i,1), As(i,2)); 

    else 
        pvother(As(i,1), As(i,2)) = PVs(As(i,1), As(i,2)); 
    end
end

% pv per trial 
pvnp = mean(pvnp', 'omitnan')'; 
pvme = mean(pvme', 'omitnan')'; 
pvother = mean(pvother', 'omitnan')'; 

% pv throughout the session
pvday = []; pred = 0; 
for d = 1:length(sessNs)
    drange = (pred+1):sessNs(d); 
    pvday(d,:) = [d, mean(pvnp(drange), 'omitnan'), mean(pvme(drange), 'omitnan'), ...
        mean(pvother(drange), 'omitnan'), mean(mean(PVs(drange,:)', 'omitnan')', 'omitnan')]; 
    pred = sessNs(d);
end

t = 1:length(sessNs); 