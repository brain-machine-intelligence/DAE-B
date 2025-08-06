clear all; 
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.05, -0.2];  
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

thr = 0.01; % activity threshold for pause 
k = 100; % number of simulations

% early, middle, late learning stages 
slist = [100 600 1500]; 
ss = {'early', 'middle', 'late'}; 

allHFD2 = struct();
for i = 1:k 
    i % to see simulation progress

    [trials, As, Qps, Qms, STNs, Qs, PVs, GPes, GPis] = BG_RNA (para, para2, para3, para4);

    for j = 1:length(slist)  
        s = ss{j}; 
        z = slist(j); 
        trialType = trials(z,5); 
        
        % compute change in firing rate during cue and outcome
        [frateB, prateB, frateCue, frateOut] = getBaseNCue (As, GPes, z, thr, trialType);
        allHFD2.(s).dFrateCue(i,:) = frateCue - frateB;             
        allHFD2.(s).dFrateOut(i,:) = frateOut - frateB;             
    
        % compute change in pause rate during cue and outcome 
        prateCue = frateCue < thr; 
        prateOut = frateOut < thr; 

        allHFD2.(s).dPrateCue(i,:) = prateCue - prateB; 
        allHFD2.(s).dPrateOut(i,:) = prateOut - prateB; 

        allHFD2.(s).prateB(i,:) = prateB; 
    end
end
save('allHFD005_2.mat', 'thr', 'tLimit', 'RwLimit', 'para', 'para2', 'para3', 'para4', 'k', 'slist', 'ss', 'allHFD2'); 

% draw
figure (2); clf; hold off; kstd = sqrt(k)*2; temp = []; 
for j = 1:length(slist)
    s = ss{j};
    
    % cue 
    x = allHFD2.(s).dPrateCue(:); 
    y = allHFD2.(s).dFrateCue(:); 
    [r, p] = corr(x,y); 
    temp(j,1:2) = [r p]; 
    subplot(2,length(slist), j); scatter (x,y,'b+'); hold on; 
    % xlim([-1 0.5]); xticks([-1 -0.5 0 0.5]);
    p = polyfit(x,y,1); 
    x_extrap = linspace (-1, 1, 10); 
    y_extrap = polyval(p, x_extrap); 
    plot(x_extrap, y_extrap, 'r-'); 
    ylabel('Cue'); title (s); 
    xlim([-1 0.7]); xticks([-1 -0.5 0 0.5]); 
    if j==3
        ylim([-0.02 0.11]); yticks([-0.02 0 0.05 0.1]);
    end

    % outcome
    x = allHFD2.(s).dPrateOut(:); 
    y = allHFD2.(s).dFrateOut(:); 
    [r, p] = corr(x,y); 
    temp(j,3:4) = [r p]; 
    subplot(2,length(slist), j+length(slist)); scatter (x,y,'b+'); hold on; 
    % xlim([-1 0.5]); xticks([-1 -0.5 0 0.5]);
    p = polyfit(x,y,1);
    x_extrap = linspace (-1, 1, 10); 
    y_extrap = polyval(p, x_extrap); 
    plot(x_extrap, y_extrap, 'r-');     
    ylabel('Outcome'); xlabel('Change in Pause Probability'); 
    xlim([-1 0.7]); xticks([-1 -0.5 0 0.5]);        
    if j==3
        ylim([-0.02 0.11]); yticks([-0.02 0 0.05 0.1]);
    end
end

% corr for lower part only 
idx = find(allHFD2.late.dFrateCue < 0.05); 
x = allHFD2.late.dPrateCue(idx);
y = allHFD2.late.dFrateCue(idx);
[r1, p1] = corr(x,y);

idx = find(allHFD2.late.dFrateOut < 0.05); 
x = allHFD2.late.dPrateOut(idx);
y = allHFD2.late.dFrateOut(idx);
[r2, p2] = corr(x,y);
temp = [temp; r1 p1 r2 p2]; 

