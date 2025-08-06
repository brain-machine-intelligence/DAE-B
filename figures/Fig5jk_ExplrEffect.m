clear all
tLimit = 1000; RwLimit = 100;
para = [20, 4000, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

% generate Qm, Qp for the start of the 2nd block 
correctA = 1; 
[trials1, As1, Qps1, Qms1, Qs1, PVs1, GPes1, GPis1] = BG_trial(para, para2, para3, para4);
[sessDurs1, Rws, NcorrectAs1, NwrongAs1, NotherAs1, sessTs1, sessNs1] = blockCut (As1, trials1, correctA, tLimit, RwLimit, 29);

% 2nd block 
para = [20, 4000, 2, 10, 100, 0.01];
Qp = Qps1(:,:,sessNs1(end)); 
Qm = Qms1(:,:,sessNs1(end)); 
correctA = 2; d = 17; 

para5 = para3; para5(4) = 0; % to see the effect of GPe-to-STN proj increase after rev
k = 100; % number of simulations 

lnp = []; rnp = []; dur = []; other = []; % for GPe-to-STN proj increase
lnp0 = []; rnp0 = []; dur0 = []; other0 = []; % for no proj increase
for i = 1:k    
    % for GPe-to-STN proj increase
    [trials2, As2, Qps2, Qms2, Qs2, PVs2, GPes2, GPis2] = BG_trial_reversal (para, para2, para3, para4, Qm, Qp, correctA); 
    [sessDurs2, Rws, NcorrectAs2, NwrongAs2, NotherAs2, sessTs2, sessNs2] = blockCut (As2, trials2, correctA, tLimit, RwLimit, d);
    lnp = [lnp; NwrongAs2'./sessDurs2']; 
    rnp = [rnp; NcorrectAs2'./sessDurs2']; 
    other = [other; NotherAs2'./sessDurs2']; 
    dur = [dur; sessDurs2']; 

    % for no proj increase
    [trials2, As2, Qps2, Qms2, Qs2, PVs2, GPes2, GPis2] = BG_trial_reversal (para, para2, para5, para4, Qm, Qp, correctA); 
    [sessDurs2, Rws, NcorrectAs2, NwrongAs2, NotherAs2, sessTs2, sessNs2] = blockCut (As2, trials2, correctA, tLimit, RwLimit, d);
    lnp0 = [lnp0; NwrongAs2'./sessDurs2']; 
    rnp0 = [rnp0; NcorrectAs2'./sessDurs2']; 
    other0 = [other0; NotherAs2'./sessDurs2']; 
    dur0 = [dur0; sessDurs2']; 

    i % to see simulation progress 
end
% save('pvRev_newCs_3.mat', 'tLimit', 'RwLimit', 'para', 'para2', 'para3', 'para4', 'k', 'd', ...
%     'lnp', 'lnp0', 'rnp', 'rnp0', 'dur', 'dur0', 'other', 'other0'); 


%% draw
% clear all
% load('pvRev_newCs_3.mat'); 
kstd = sqrt(k)*2; 

figure(2); clf; hold off;
% lnp
subplot(2,4,3); 
shadedErrorBar(1:17, mean(lnp(:,1:17)), std(lnp(:,1:17))/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:17, mean(lnp0(:,1:17)), std(lnp0(:,1:17))/kstd, 'lineProps', '-k'); hold on; 
ylabel('LNP rate'); xlabel('Day'); xlim([1 17]);

pstar = [];  
for i = 1:17
    [ps(i,1), ~, ~] = ranksum(lnp(:,i), lnp0(:,i)); 
    if ps(i,1) < 0.05
        pstar = [pstar; i];
    end 
end
y = ones(length(pstar), 1) * (max(mean(lnp(:,1:17))) + 0.05); 
scatter(pstar, y, 'sk', 'filled'); hold off; 

% rnp 
subplot(2,4,4); 
shadedErrorBar(1:17, mean(rnp(:,1:17)), std(rnp(:,1:17))/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:17, mean(rnp0(:,1:17)), std(rnp0(:,1:17))/kstd, 'lineProps', '-k'); hold on; 
ylabel('RNP rate'); xlabel('Day'); xlim([1 17]);

pstar = [];  ps = []; 
for i = 1:17
    [ps(i,1), ~, ~] = ranksum(rnp(:,i), rnp0(:,i)); 
    if ps(i,1) < 0.05
        pstar = [pstar; i];
    end 
end
y = ones(length(pstar), 1) * (max(mean(rnp(:,1:17))) + 0.05); 
scatter(pstar, y, 'sk', 'filled'); hold off; 

% NonInst
subplot(2,4,1); 
shadedErrorBar(1:17, mean(other(:,1:17)), std(other(:,1:17))/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:17, mean(other0(:,1:17)), std(other0(:,1:17))/kstd, 'lineProps', '-k'); hold on; 
ylabel('NonInst rate'); xlabel('Day'); xlim([1 17]);

pstar = [];  ps = []; 
for i = 1:17
    [ps(i,1), ~, ~] = ranksum(other(:,i), other0(:,i)); 
    if ps(i,1) < 0.05
        pstar = [pstar; i];
    end 
end
y = ones(length(pstar), 1) * (max(mean(other(:,1:17))) + 0.05); 
scatter(pstar, y, 'sk', 'filled'); hold off; 

% dur
subplot(2,4,2); 
shadedErrorBar(1:17, mean(dur(:,1:17)), std(dur(:,1:17))/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:17, mean(dur0(:,1:17)), std(dur0(:,1:17))/kstd, 'lineProps', '-k'); hold on; 
ylabel('Session duration'); xlabel('Day'); xlim([1 17]);

pstar = [];  ps = []; 
for i = 1:17
    [ps(i,1), ~, ~] = ranksum(dur(:,i), dur0(:,i)); 
    if ps(i,1) < 0.05
        pstar = [pstar; i];
    end 
end
y = ones(length(pstar), 1) * (max(mean(dur(:,1:17))) + 0.05); 
scatter(pstar, y, 'sk', 'filled'); hold off; 


% first 5 days exploration 
otherAll = round(other .* dur); 
other5f  = sum(otherAll(:,1:5)')';
otherAll0 = round(other0 .* dur0); 
other5f0  = sum(otherAll0(:,1:5)')';
kstd = sqrt(100)*2;

figure(2); subplot(2,4,5); 
b = bar([mean(other5f) mean(other5f0)], 'FaceColor','flat'); 
b.CData(1,:) = [1, 0, 0]; 
b.CData(2,:) = [0, 0, 0]; hold on; 
title ('NonInst during the first 5 days')

errorbar([1 2], [mean(other5f) mean(other5f0)], [std(other5f) std(other5f0)]/kstd, 'k', 'linestyle', 'none'); 
ylim([2000 3500])
ranksum(other5f, other5f0) %  6.0335e-30


% last 5 days reward
rrAll = 100 ./ dur; 
rr5l  = sum(rrAll(:,13:17)')'/5;
rrAll0 = 100 ./ dur0; 
rr5l0  = sum(rrAll0(:,13:17)')'/5;
kstd = sqrt(100)*2;

figure(2); subplot(2,4,6); hold off; 
b = bar([mean(rr5l) mean(rr5l0)], 'FaceColor','flat'); 
b.CData(1,:) = [1, 0, 0]; 
b.CData(2,:) = [0, 0, 0]; hold on; 
title ('Reward Rate during the last 5 days')

errorbar([1 2], [mean(rr5l) mean(rr5l0)], [std(rr5l) std(rr5l0)]/kstd, 'k', 'linestyle', 'none'); 
% ylim([0.4 0.5]); yticks([0.4 0.45 0.5]); 
ranksum(rr5l, rr5l0) %    4.2294e-14

