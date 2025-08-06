clear all
tLimit = 1000; RwLimit = 100;
para = [20, 2000, 1, 10, 100];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; % or para3 = [0.5, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

[trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);    

% find representative trials from early and late stages
et = find(trials(1:200,2)==19); 
lt = find(trials(1500:1550, 2)==2); 
lt = lt + 1499; 

% draw 
% load("Fig2aResults.mat");
figure(1); clf; hold off;  % Qp and Qm
[GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, et(1)); % should pick an et element whose value is ~100
subplot(2,4,1); heatmap(Qp); title(["dMSN", ['Early']]);
subplot(2,4,2); heatmap(Qm); title("iMSN");
subplot(2,4,3); heatmap(GPe); title("GPe");
subplot(2,4,4); heatmap(GPi); title("GPi"); 

[GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, lt(1)); 
subplot(2,4,5); heatmap(Qp); title(["dMSN", ['Late']]);
subplot(2,4,6); heatmap(Qm); title("iMSN");
subplot(2,4,7); heatmap(GPe); title("GPe");
subplot(2,4,8); heatmap(GPi); title("GPi");
