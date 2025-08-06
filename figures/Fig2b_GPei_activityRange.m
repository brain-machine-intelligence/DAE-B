clear all
tLimit = 1000; RwLimit = 100;
para = [20, 2000, 1, 10, 100];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para3 = [0.5, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

% Number of simulation
k = 100; kstd = sqrt(k) * 2; 

% output
gpeA9 = struct(); gpiA9 = struct(); % for W_GPe_to_STN = 0.9
gpeA5 = struct(); gpiA5 = struct(); % for W_GPe_to_STN = 0.5 

for i = 1:k
    i % to see simulation progress
    
    para3(1) = 0.9; 
    % para3(1) = 0.66; para3(2) = 1.5; % for suppl fig 5
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);   

    for z = 1:1500 
        [minA, maxA, meanA] = getMinMaxMean (As, GPes, z); 
        gpeA9.minA(i,z) = minA; 
        gpeA9.maxA(i,z) = maxA; 
        gpeA9.meanA(i,z) = meanA; 

        [minA, maxA, meanA] = getMinMaxMean (As, GPis, z); 
        gpiA9.minA(i,z) = minA; 
        gpiA9.maxA(i,z) = maxA; 
        gpiA9.meanA(i,z) = meanA; 
    end

    para3(1) = 0.5; 
    % para3(1) = 0.37; para3(2) = 1.5; % for suppl fig 5
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);   
     
    for z = 1:1500 
        [minA, maxA, meanA] = getMinMaxMean (As, GPes, z); 
        gpeA5.minA(i,z) = minA; 
        gpeA5.maxA(i,z) = maxA; 
        gpeA5.meanA(i,z) = meanA; 

        [minA, maxA, meanA] = getMinMaxMean (As, GPis, z); 
        gpiA5.minA(i,z) = minA; 
        gpiA5.maxA(i,z) = maxA; 
        gpiA5.meanA(i,z) = meanA; 
    end
end
save("Fig1bResults.mat"); 

figure(1); clf; hold off; 
% load("Fig1bResults.mat"); 
subplot(1,2,1); t = 1:1500; 
shadedErrorBar(t, mean(gpeA9.meanA),  std(gpeA9.meanA)/kstd, 'lineProp','-k'); hold on; 
shadedErrorBar(t, mean(gpeA9.minA),  std(gpeA9.minA)/kstd, 'lineProp', {'-', 'Color', [0.1, 0.6, 0.2]}); hold on; 
shadedErrorBar(t, mean(gpeA9.maxA),  std(gpeA9.maxA)/kstd, 'lineProp','-r'); hold on; 

shadedErrorBar(t, mean(gpiA9.meanA),  std(gpiA9.meanA)/kstd, 'lineProp',{'-', 'Color', [0.5, 0.5, 0.5]} ); hold on; 
shadedErrorBar(t, mean(gpiA9.minA),  std(gpiA9.minA)/kstd, 'lineProp',{'-', 'Color', [0.7, 0.85, 0.6]} ); hold on; 
shadedErrorBar(t, mean(gpiA9.maxA),  std(gpiA9.maxA)/kstd, 'lineProp',{'-', 'Color', [1, 0.5, 0.5]} ); hold on; 
xlabel('Trial'); ylabel('Unit Activity'); xlim([0 1500]); 
ylim([-0.05 1.05]); 

subplot(1,2,2); t = 1:1500; 
shadedErrorBar(t, mean(gpeA5.meanA),  std(gpeA5.meanA)/kstd, 'lineProp','-k'); hold on; 
shadedErrorBar(t, mean(gpeA5.minA),  std(gpeA5.minA)/kstd, 'lineProp', {'-', 'Color', [0.1, 0.6, 0.2]}); hold on; 
shadedErrorBar(t, mean(gpeA5.maxA),  std(gpeA5.maxA)/kstd, 'lineProp','-r'); hold on; 

shadedErrorBar(t, mean(gpiA5.meanA),  std(gpiA5.meanA)/kstd, 'lineProp',{'-', 'Color', [0.5, 0.5, 0.5]}); hold on; 
shadedErrorBar(t, mean(gpiA5.minA),  std(gpiA5.minA)/kstd, 'lineProp',{'-', 'Color', [0.7, 0.85, 0.6]}); hold on; 
shadedErrorBar(t, mean(gpiA5.maxA),  std(gpiA5.maxA)/kstd, 'lineProp',{'-', 'Color', [1, 0.5, 0.5]} ); hold on; 
xlabel('Trial'); ylabel('Unit Activity'); xlim([0 1500]); 
ylim([-0.05 1.05]); 



