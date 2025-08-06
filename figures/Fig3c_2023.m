clear all; tLimit = 1000; RwLimit = 100;
para = [20, 1700, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.05, -0.2];  
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

thr = 0.01; % activity threshold for pause 
k = 100; % number of simulations

% early, middle, late learning stages 
slist = [100 600 1500]; 
ss = {'early', 'middle', 'late'}; 

% simulate to draw fig 3c
allHFD = struct(); 
for i = 1:k 
    i % to see simulation progress

    [trials, As, Qps, Qms, STNs, Qs, PVs, GPes, GPis] = BG_RNA (para, para2, para3, para4);

    for j = 1:length(slist)  
        s = ss{j}; 
        z = slist(j); 

        for trialType = 1:3
            % find the first trial of the target trial type since z-th trial 
            [newz] = getTargetTrial (trials, z, trialType); 

            % compute the change in firing rate (cue - baseline)
            [frateB, prateB, frateCue, frateOut] = getBaseNCue (As, GPes, newz, thr, trialType);
            drate = mean(frateCue - frateB);             
            allHFD.(s)(i,trialType) = drate; 
        end
    end
end
save('allHFD005.mat', 'thr', 'tLimit', 'RwLimit', 'para', 'para2', 'para3', 'para4', 'k', 'slist', 'ss', 'allHFD'); 

% replicate Fig 3B bottom in dichotomous 2023
figure (1); clf; hold off; kstd = sqrt(k)*2; 
s = 'late';
bar(mean(allHFD.(s))); hold on;
errorbar(mean(allHFD.(s)), std(allHFD.(s))/kstd, 'k', 'linestyle', 'none');
title (s);

ranksum(allHFD.late(:,1), allHFD.late(:,2)) %  2.5621e-34
ranksum(allHFD.late(:,1), allHFD.late(:,3)) %  2.5621e-34