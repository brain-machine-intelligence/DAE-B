clear all   
tLimit = 1000; RwLimit = 100;
para = [20, 8000, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2];  

d = 60; % train until day 60 for extensive training 
k = 100; kstd = sqrt(k)*2; % number of simulations 
correctA = 1; 


% unit activity range(max val) + behavioral deterioration 
% for large W_GPe_to_STN
lnp = []; rnp = []; other = []; dur = []; 
imsn = []; dmsn = []; gpe = []; gpi = []; 

% for small W_GPe_to_STN
para5 = [0.5, 1.1, 4, 1, 0.0005, 1]; 
lnp2 = []; rnp2 = []; other2 = []; dur2 = []; 
imsn2 = []; dmsn2 = []; gpe2 = []; gpi2 = []; 

for i = 1:k 
    % with large pvf
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_trial (para, para2, para3, para4);
    [sessDurs1, Rws, NcorrectAs1, NwrongAs1, NotherAs1, sessTs1, sessNs1] = blockCut (As, trials, correctA, tLimit, RwLimit, d);
    lnp(i,:) = [NcorrectAs1./sessDurs1]; 
    rnp(i,:) = [NwrongAs1./sessDurs1]; 
    other(i,:) = [NotherAs1./sessDurs1]/7; 
    dur(i,:) = [sessDurs1]; 

    for z = 1:6000 
        imsn(i,z) = getActRange (Qms, z);
        dmsn(i,z) = getActRange (Qps, z);
        gpe(i,z) = getActRange (GPes, z);
        gpi(i,z) = getActRange (GPis, z);
    end

    % with medium pvf
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_trial (para, para2, para5, para4);
    [sessDurs1, Rws, NcorrectAs1, NwrongAs1, NotherAs1, sessTs1, sessNs1] = blockCut (As, trials, correctA, tLimit, RwLimit, d);
    lnp2(i,:) = [NcorrectAs1./sessDurs1]; 
    rnp2(i,:) = [NwrongAs1./sessDurs1]; 
    other2(i,:) = [NotherAs1./sessDurs1]/7; 
    dur2(i,:) = [sessDurs1];  

    for z = 1:6000 
        imsn2(i,z) = getActRange (Qms, z);
        dmsn2(i,z) = getActRange (Qps, z);
        gpe2(i,z) = getActRange (GPes, z);
        gpi2(i,z) = getActRange (GPis, z);
    end
    i 
end


figure(1); clf; 
t = 1:6000; kstd = sqrt(k)*2; 
% pvf = 0.9
subplot(1,3,1);  
shadedErrorBar(t, mean(imsn), std(imsn)/kstd, 'lineProps', '-b'); hold on; 
shadedErrorBar(t, mean(gpe), std(gpe)/kstd, 'lineProps', '-r'); hold on; 
xlabel('Trial'); ylabel('Max Activity'); title ('Qm vs GPe'); ylim([0 0.35]); 
xticks([0 3000 6000]); yticks([0 0.1 0.2 0.3]); 

subplot(1,3,2);  
shadedErrorBar(1:d, mean(lnp(:,1:d)), std(lnp)/kstd, 'lineProps', '-b'); hold on; 
shadedErrorBar(1:d, mean(rnp(:,1:d)), std(rnp)/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:d, mean(other(:,1:d)), std(other)/kstd, 'lineProps', '-k'); hold on; 
xlim([1 d]); xlabel('Day'); ylabel('Behavior Rate'); title('pvf = 0.9'); ylim([0 0.5]);

subplot(1,3,3);  
shadedErrorBar(1:d, mean(dur(:,1:d)), std(dur)/kstd, 'lineProps', '-k'); hold on; 
xlim([1 d]); xlabel('Day'); ylabel('Session Duration'); title('pvf = 0.9'); 
ylim([0 1000]); yticks([0 200 400 600 800 1000]);

figure(2); clf; 
% pvf = 0.5
subplot(1,3,1);  
shadedErrorBar(t, mean(imsn2), std(imsn2)/kstd, 'lineProps', '-b'); hold on; 
shadedErrorBar(t, mean(gpe2), std(gpe2)/kstd, 'lineProps', '-r'); hold on; 
xlabel('Trial'); ylabel('Max Activity'); title ('Qm vs GPe'); ylim([0 0.35]); 
xticks([0 3000 6000]); yticks([0 0.1 0.2 0.3]); 

subplot(1,3,2);  
shadedErrorBar(1:d, mean(lnp2(:,1:d)), std(lnp2)/kstd, 'lineProps', '-b'); hold on; 
shadedErrorBar(1:d, mean(rnp2(:,1:d)), std(rnp2)/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:d, mean(other2(:,1:d)), std(other2)/kstd, 'lineProps', '-k'); hold on; 
xlim([1 d]); xlabel('Day'); ylabel('Behavior Rate'); title('pvf = 0.5'); ylim([0 0.5]);

subplot(1,3,3);  
shadedErrorBar(1:d, mean(dur2(:,1:d)), std(dur2)/kstd, 'lineProps', '-k'); hold on; 
xlim([1 d]); xlabel('Day'); ylabel('Session Duration'); title('pvf = 0.5'); hold off; 
ylim([0 1000]); yticks([0 200 400 600 800 1000]);
