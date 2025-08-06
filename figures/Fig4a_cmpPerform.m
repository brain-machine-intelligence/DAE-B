clear all
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2, 1, 0.01];

% Number of simulation
k = 100; kstd = sqrt(k)*2;  

% output: correct response and session length
lnp = []; dur = []; 

% simulate for W_GPe_to_STN = 0.9 and 0.5 
for i = 1:k
    para3(1) = 0.9; 
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_trial (para, para2, para3, para4);
    
    for j = 1:1500        
        r(i,j,1) = trials(j,4); 
        dur(i,j,1) = trials(j,2); 
    end

    para3(1) = 0.5; 
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_trial (para, para2, para3, para4);
    
    for j = 1:1500        
        r(i,j,2) = trials(j,4); 
        dur(i,j,2) = trials(j,2); 
    end
end

% significance test 
sigr = zeros(1500,1); sigd = zeros(1500,1);
for j = 1:1500
    [p, ~, ~] = ranksum(r(:,j,1), r(:,j,2)); 
    if p < 0.05
        sigr(j) = 1; 
    end
    
    [p, ~, ~] = ranksum(dur(:,j,1), dur(:,j,2)); 
    if p < 0.05
        sigd(j) = 1; 
    end
end

% draw
figure(1);  clf; hold off;
subplot(1,2,1); t = 1:1500;
shadedErrorBar(t, mean(r(:,:,1),1), std(r(:,:,1),0,1)/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(t, mean(r(:,:,2),1), std(r(:,:,2),0,1)/kstd, 'lineProps', {'-', 'Color', [0.6,0.6,0.6]} ); hold on; 
x = find(sigr==1); y = ones(length(x),1) * 1.1; 
scatter (x,y, 'sk', 'filled'); 
ylabel('Reward rate'); xlabel('Trial'); ylim([0 1.2]); yticks([0 0.5 1]);

subplot(1,2,2); 
shadedErrorBar(t, mean(dur(:,:,1),1), std(dur(:,:,1),0,1)/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(t, mean(dur(:,:,2),1), std(dur(:,:,2),0,1)/kstd, 'lineProps', {'-', 'Color', [0.6,0.6,0.6]} ); hold on; 
x = find(sigd(1:880)==1); y = ones(length(x),1) * 12; 
x1 = [881 1000 1500]; y1 = [12 12 12]; 
scatter (x,y, 'sk', 'filled'); hold on; 
plot(x1, y1, '-k'); 
ylabel('Trial length'); xlabel('Trial'); ylim([0 13]); yticks([0 5 10]);

