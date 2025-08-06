% To simulate animal behavior in figure 5. 

function [y, yraw, pvday] = BGfit(para2, para3, para4, tLimit, RwLimit)

% 1st block LNP
para = [20, 4000, 1, 10, 100, 0.01];
correctA = 1; 
[trials1, As1, Qps1, Qms1, Qs1, PVs1, GPes1, GPis1] = BG_trial (para, para2, para3, para4);
[sessDurs1, Rws, NcorrectAs1, NwrongAs1, NotherAs1, sessTs1, sessNs1] = blockCut (As1, trials1, correctA, tLimit, RwLimit, 29);
[pvday1] = getPV(PVs1, As1, sessNs1, sessTs1, correctA); 

% 2nd block RNP
para = [20, 4000, 2, 10, 100, 0.01];
Qp = Qps1(:,:,sessNs1(end)); 
Qm = Qms1(:,:,sessNs1(end)); 
correctA = 2; 
[trials2, As2, Qps2, Qms2, Qs2, PVs2, GPes2, GPis2] = BG_trial_reversal (para, para2, para3, para4, Qm, Qp, correctA); 
[sessDurs2, Rws, NcorrectAs2, NwrongAs2, NotherAs2, sessTs2, sessNs2] = blockCut (As2, trials2, correctA, tLimit, RwLimit, 17);
[pvday2] = getPV(PVs2, As2, sessNs2, sessTs2, correctA); 

% 3rd block RNP
para = [20, 1000, 1, 10, 100, 0.01];
Qp = Qps2(:,:,sessNs2(end)); 
Qm = Qms2(:,:,sessNs2(end)); 
correctA = 1; para3(4) = 0; 
[trials3, As3, Qps3, Qms3, Qs3, PVs3, GPes3, GPis3] = BG_trial_reversal (para, para2, para3, para4, Qm, Qp, correctA); 
[sessDurs3, Rws, NcorrectAs3, NwrongAs3, NotherAs3, sessTs3, sessNs3] = blockCut (As3, trials3, correctA, tLimit, RwLimit, 4);
[pvday3] = getPV(PVs3, As3, sessNs3, sessTs3, correctA); 

% 4th block RNP
para = [20, 1000, 2, 10, 100, 0.1];
Qp = Qps3(:,:,sessNs3(end)); 
Qm = Qms3(:,:,sessNs3(end)); 
correctA = 2; para3(4) = 0; 
[trials4, As4, Qps4, Qms4, Qs4, PVs4, GPes4, GPis4] = BG_trial_reversal (para, para2, para3, para4, Qm, Qp, correctA); 
[sessDurs4, Rws, NcorrectAs4, NwrongAs4, NotherAs4, sessTs4, sessNs4] = blockCut (As4, trials4, correctA, tLimit, RwLimit, 4);
[pvday4] = getPV(PVs4, As4, sessNs4, sessTs4, correctA); 

% all toghether
y = []; 
y(:,1) = [NcorrectAs1./sessDurs1 ; NwrongAs2./sessDurs2 ; NcorrectAs3./sessDurs3 ; NwrongAs4./sessDurs4]; %lnp
y(:,2) = [NwrongAs1./sessDurs1; NcorrectAs2./sessDurs2; NwrongAs3./sessDurs3; NcorrectAs4./sessDurs4]; %rnp
y(:,4) = [NotherAs1./sessDurs1; NotherAs2./sessDurs2; NotherAs3./sessDurs3; NotherAs4./sessDurs4]; %other
y(:,3) = [sessDurs1; sessDurs2; sessDurs3; sessDurs4]; % dur
pvday = [pvday1; pvday2; pvday3; pvday4];

% scale
% m = max(y(:,1)); n = max(y(:,4));
% y(:,1) = y(:,1) / m; 
% y(:,2) = y(:,2) / m; 
% y(:,4) = y(:,4) / m; 
% y(:,3) = y(:,3) / tLimit; 

% raw number 
yraw = []; 
yraw(:,1) = [NcorrectAs1; NwrongAs2; NcorrectAs3; NwrongAs4]; %lnp
yraw(:,2) = [NwrongAs1; NcorrectAs2; NwrongAs3; NcorrectAs4]; %rnp
yraw(:,4) = [NotherAs1; NotherAs2; NotherAs3; NotherAs4]; %other
yraw(:,3) = [sessDurs1; sessDurs2; sessDurs3; sessDurs4]; % dur

