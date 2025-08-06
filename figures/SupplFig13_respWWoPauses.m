clear all
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

thr = 0.01; % threshold for pause
k = 100; kstd = sqrt(k)*2;  % number of simulations 

% compare # of exploration with and without pauses. 
pauseE = nan(k,1500); NpauseE = nan(k, 1500); 
pauseI = nan(k,1500); NpauseI = nan(k, 1500); 

for i = 1:k
    % nonInst behavior throughout learning     
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);

    for z = 1:1500
        [pauseExpl, NpauseExpl] = getPauseExplore (GPes, As, thr, z); 
        pauseE (i,z) = pauseExpl; 
        NpauseE (i,z) = NpauseExpl; 
        
        [pauseInst, NpauseInst] = getPauseInst (GPes, As, thr, z); 
        pauseI (i,z) = pauseInst; 
        NpauseI (i,z) = NpauseInst; 
    end   

    i % to see simulation progress 
end

figure(4); clf; hold off; subplot (1,2,1); 
shadedErrorBar(1:1500, mean(pauseE), std(pauseE)/kstd, 'lineProps', '-r'); hold on; % pause exploration
shadedErrorBar(1:1500, mean(NpauseE), std(NpauseE)/kstd, 'lineProps', '-k'); hold on; % no pause exploration
ylabel('# of Non-Inst'); xlabel('Trial'); xlim([1, 1500]); ylim([-2 10]); 
xticks([500, 1000, 1500]); yticks([-2 0 5 10]); 

subplot (1,2,2); 
shadedErrorBar(1:1500, mean(pauseI), std(pauseI)/kstd, 'lineProps', '-r'); hold on; % pause exploration
shadedErrorBar(1:1500, mean(NpauseI), std(NpauseI)/kstd, 'lineProps', '-k'); hold on; % no pause exploration
ylabel('# of Inst'); xlabel('Trial'); xlim([1, 1500]); ylim([-2 10]); 
xticks([500, 1000, 1500]); yticks([-2 0 5 10]); 
 