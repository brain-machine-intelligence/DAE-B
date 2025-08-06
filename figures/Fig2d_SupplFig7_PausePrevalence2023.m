clear all
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 
thr = 0.01; % activity threshold for pause

% Number of simulation
k = 100; kstd = sqrt(k) * 2; 

% early, middle, late stage
etrial = 100; mtrial = 600; ltrial = 1500; 

% output
frpr = struct(); frpr.e = []; frpr.m = []; frpr.l = [];

for i = 1:k
    i % to see simulation progress 

    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep(para, para2, para3, para4);

    % compute firing rate (fr; mean unit activity), pause rate and corrected firing rate (frc)    
    [fr, pr, frc] = getFrPr (As, GPes, etrial, thr); 
    frpr.e = [frpr.e; fr' pr' frc']; 
    
    [fr, pr, frc] = getFrPr (As, GPes, mtrial, thr); 
    frpr.m = [frpr.m; fr' pr' frc']; 

    [fr, pr, frc] = getFrPr (As, GPes, ltrial, thr); 
    frpr.l = [frpr.l; fr' pr' frc'];     
end

% draw fig 2d and suppl fig 7ab
stages = {'e', 'm', 'l'}; tss = {'Early', 'Middle', 'Late'};
figure(1); clf; hold off; temp = [];
for i = 1:6
    if i<=3 
        ss = stages{i}; 
        ts = tss{i}; 
        x = frpr.(ss)(:,1); y = frpr.(ss)(:,2);
        tempr = i; tempc = 1:2; % to specify idx of correlation r and p in temp

    else 
        ss = stages{i-3};
        ts = tss{i-3}; 
        x = frpr.(ss)(:,3); y = frpr.(ss)(:,2);
        tempr = i-3; tempc = 3:4; % to specify idx of correlation r and p in temp
    end    

    subplot(3,3,i);
    scatter(x,y, 100, 's', 'filled', 'MarkerFaceColor', [1 0.5 0], 'MarkerEdgeColor', 'w'); hold on;    
    ylim([0 1]); yticks([0 0.5 1]);
    xlabel('Mean Unit Activity'); ylabel('Pause Rate'); title(ts);

    [r,p] = corr(x,y); temp(tempr,tempc) = [r, p];

    p = polyfit(x,y,1);
    fitx = [min(x), max(x)];  fity = polyval(p, fitx);
    plot(fitx, fity,'-r');
end 
frpr1 = frpr; temp1 = temp; 


%% draw suppl fig 7c (use exp paradigm in fig 3b)
% used different value for softm to simulate exp paradigm in fig 3b
para2 = [0.001, 0.001, 0.9, 0.9, 0.05, -0.2];  

% output
frpr = struct(); frpr.e = []; frpr.m = []; frpr.l = [];

for i = 1:k    
    [trials, As, Qps, Qms, STNs, Qs, PVs, GPes, GPis] = BG_RNA (para, para2, para3, para4);

    [fr, pr, frc] = getFrPr (As, GPes, etrial, thr); 
    frpr.e = [frpr.e; fr' pr' frc']; 
    
    [fr, pr, frc] = getFrPr (As, GPes, mtrial, thr); 
    frpr.m = [frpr.m; fr' pr' frc']; 

    [fr, pr, frc] = getFrPr (As, GPes, ltrial, thr); 
    frpr.l = [frpr.l; fr' pr' frc']; 
    i
end

stages = {'e', 'm', 'l'}; tss = {'Early', 'Middle', 'Late'};
figure(1); temp2 = [];
for i = 1:3    
    ss = stages{i};
    ts = tss{i};
    x = frpr.(ss)(:,1); y = frpr.(ss)(:,2);
    tempr = i; tempc = 1:2; % to specify idx of correlation r and p in temp2

    subplot(3,3,i+6);
    scatter(x,y, 100, 's', 'filled', 'MarkerFaceColor', [1 0.5 0], 'MarkerEdgeColor', 'w'); hold on;
    xlabel('Mean Unit Activity'); ylabel('Pause Rate'); title(ts);
    ylim([0.4 1]); yticks([0.4 0.7 1]);

    [r,p] = corr(x,y); temp2(tempr,tempc) = [r, p];

    p = polyfit(x,y,1);
    fitx = [min(x), max(x)];  fity = polyval(p, fitx);
    plot(fitx, fity,'-r');
end
frpr2 = frpr; 