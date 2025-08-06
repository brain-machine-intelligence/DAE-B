clear all
tLimit = 1000; RwLimit = 100;
para = [20, 4000, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

% 1st block LNP
correctA = 1; 
[trials1, As1, Qps1, Qms1, Qs1, PVs1, GPes1, GPis1] = BG_trial (para, para2, para3, para4);
[sessDurs1, Rws, NcorrectAs1, NwrongAs1, NotherAs1, sessTs1, sessNs1] = blockCut (As1, trials1, correctA, tLimit, RwLimit, 29);

% 2nd block RNP
para = [20, 6000, 2, 10, 100, 0.01];
Qp = Qps1(:,:,sessNs1(end)); 
Qm = Qms1(:,:,sessNs1(end)); 
correctA = 2; 
[trials2, As2, Qps2, Qms2, Qs2, PVs2, GPes2, GPis2] = BG_trial_reversal (para, para2, para3, para4, Qm, Qp, correctA); 
[sessDurs2, Rws, NcorrectAs2, NwrongAs2, NotherAs2, sessTs2, sessNs2] = blockCut (As2, trials2, correctA, tLimit, RwLimit, 17);

% draw
t = [1500, 10, 100, 1500]; 
figure(7); clf; 
% immdeately before reversal 
subplot(4,4,1); h = heatmap(Qps1(1:19,:,t(1))); title(["dMSN", ['trial ' num2str(t(1))]]); 
h.ColorLimits = [0.05 0.7]; 
subplot(4,4,2); h = heatmap(Qms1(1:19,:,t(1))); title(["iMSN", ['trial ' num2str(t(1))]]);
h.ColorLimits = [0 0.2]; 
subplot(4,4,3); h = heatmap(GPes1(1:19,:,t(1))); title(["GPe", ['trial ' num2str(t(1))]]);
h.ColorLimits = [0 0.22]; 
subplot(4,4,4); h = heatmap(GPis1(1:19,:,t(1))); title(["GPi", ['trial ' num2str(t(1))]]);
h.ColorLimits = [0 0.75]; 

% after reversal 
subplot(4,4,5); h = heatmap(Qps2(1:19,:,t(2)));  title(['trial ' num2str(t(2))]);
h.ColorLimits = [0.05 0.7]; 
subplot(4,4,6); h = heatmap(Qms2(1:19,:,t(2))); 
h.ColorLimits = [0 0.2]; 
subplot(4,4,7); h = heatmap(GPes2(1:19,:,t(2))); title(['trial ' num2str(t(2))]);
h.ColorLimits = [0 0.22]; 
subplot(4,4,8); h = heatmap(GPis2(1:19,:,t(2))); 
h.ColorLimits = [0 0.75]; 

subplot(4,4,9); h = heatmap(Qps2(1:19,:,t(3))); title(['trial ' num2str(t(3))]);
h.ColorLimits = [0.05 0.7]; 
subplot(4,4,10); h = heatmap(Qms2(1:19,:,t(3))); 
h.ColorLimits = [0 0.2]; 
subplot(4,4,11); h = heatmap(GPes2(1:19,:,t(3))); title(['trial ' num2str(t(3))]);
h.ColorLimits = [0 0.22]; 
subplot(4,4,12); h = heatmap(GPis2(1:19,:,t(3))); 
h.ColorLimits = [0 0.75]; 

subplot(4,4,13); h = heatmap(Qps2(1:19,:,t(4))); title(['trial ' num2str(t(4))]);
h.ColorLimits = [0.05 0.7]; 
subplot(4,4,14); h = heatmap(Qms2(1:19,:,t(4))); 
h.ColorLimits = [0 0.2]; 
subplot(4,4,15); h = heatmap(GPes2(1:19,:,t(4))); title(['trial ' num2str(t(4))]);
h.ColorLimits = [0 0.22]; 
subplot(4,4,16); h = heatmap(GPis2(1:19,:,t(4))); 
h.ColorLimits = [0 0.75]; 

