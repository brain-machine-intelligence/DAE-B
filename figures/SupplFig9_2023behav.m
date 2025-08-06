% to reproduce fig 1B in dichotomous 2023

clear all; 
tLimit = 500; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.05, -0.2];  
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

ltrial = 1500; k = 20; 
Alick= nan(k,3); Ablink = nan(k,3); Anon = nan(k,3); 
Nlick= nan(k,3); Nblink = nan(k,3); Nnon = nan(k,3); 
Rlick= nan(k,3); Rblink = nan(k,3); Rnon = nan(k,3); 

% simulate 
for i = 1:k 
    i
    [trials, As, Qps, Qms, STNs, Qs, PVs, GPes, GPis] = BG_RNA (para, para2, para3, para4, 0);

    % reward trial
    [newz] = getTargetTrial (trials, ltrial, 1);
    Rlick(i,:) = getRNAcrRate (As, newz, 1); 
    Rblink(i,:) = getRNAcrRate (As, newz, 2); 
    Rnon(i,:) = getRNAcrRate (As, newz, 0); 

    % neutral trial
    [newz] = getTargetTrial (trials, ltrial, 2);
    Nlick(i,:) = getRNAcrRate (As, newz, 1); 
    Nblink(i,:) = getRNAcrRate (As, newz, 2); 
    Nnon(i,:) = getRNAcrRate (As, newz, 0); 

    % aversive trial 
    [newz] = getTargetTrial (trials, ltrial, 3);
    Alick(i,:) = getRNAcrRate (As, newz, 1); 
    Ablink(i,:) = getRNAcrRate (As, newz, 2); 
    Anon(i,:) = getRNAcrRate (As, newz, 0);    
end

% draw
figure (1); clf; hold off; kstd = sqrt(k)*2; subplot(1,2,1); 
plot(1:3, mean(Rlick), '-b', 1:3, mean(Alick), '-r', 1:3, mean(Nlick), '-g'); 
xticks([1:3]); xticklabels({'Baseline', 'Cue', 'Outcome'}); 
yticks([0 0.5 1]); ylabel('Licking Rate'); 

subplot(1,2,2); 
plot(1:3, mean(Rblink), '-b', 1:3, mean(Ablink), '-r', 1:3, mean(Nblink), '-g'); 
xticks([1:3]); xticklabels({'Baseline', 'Cue', 'Outcome'}); 
yticks([0 0.1 0.2 0.3 0.4 0.5]); ylabel('Blinking Rate'); ylim([0 0.5])
