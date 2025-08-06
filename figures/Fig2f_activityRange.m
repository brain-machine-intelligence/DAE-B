clear all
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 5, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

stages = {'early', 'middle', 'late'}; 
staget = [100 600 1500];

% Number of simulation
k = 100; kstd = sqrt(k)*2; 

% simulate 
GPeRange = struct(); 
for i = 1:k
    i % to see simulation progress 

    % DAE-B model 
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);

    for s = 1:length(stages)
        stage = stages{s}; 
        [postGPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, staget(s));
        [preGPe] = getPreGPeActivity (Qm, para3, para4);
        GPeRange.DAEB.(stage)(i,1) = max(max(preGPe)) - min(min(preGPe));
        GPeRange.DAEB.(stage)(i,2) = max(max(postGPe)) - min(min(postGPe));
        GPeRange.DAEB.(stage)(i,3) = GPeRange.DAEB.(stage)(i,2) / GPeRange.DAEB.(stage)(i,1); 
    end 
    
    % Model with action-specific connectiivty 
    [trials, As, Qps, Qms, Qs, GPes, GPis] = BG_tStep_topographic (para, para2, para3, para4);    

    for s = 1:length(stages)
        stage = stages{s}; 
        [postGPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, staget(s));
        [preGPe] = getPreGPeActivity (Qm, para3, para4);
        GPeRange.topo.(stage)(i,1) = max(max(preGPe)) - min(min(preGPe));
        GPeRange.topo.(stage)(i,2) = max(max(postGPe)) - min(min(postGPe));
        GPeRange.topo.(stage)(i,3) = GPeRange.topo.(stage)(i,2) / GPeRange.topo.(stage)(i,1); 
    end     
end


%% draw figure: bar 
figure(4); clf; hold off;  

DAEB = [GPeRange.DAEB.early(:,3) GPeRange.DAEB.middle(:,3) GPeRange.DAEB.late(:,3)];
topo = [GPeRange.topo.early(:,3) GPeRange.topo.middle(:,3) GPeRange.topo.late(:,3)];

b = bar([mean(DAEB)' mean(topo)'], 'EdgeColor', 'none'); hold on;
b(1).FaceColor = 'k';
b(2).FaceColor = 'm';

% Get the x coordinates of the bars
xc = nan(size([mean(DAEB)' mean(topo)']));
for i = 1:size(xc, 2)
    xc(:,i) = b(i).XEndPoints;
end

% Add error bars
errorbar(xc(:,1), mean(DAEB), std(DAEB)/kstd, 'k', 'linestyle', 'none', 'LineWidth', 0.25);
errorbar(xc(:,2), mean(topo), std(topo)/kstd, 'm', 'linestyle', 'none', 'LineWidth', 0.25);
set(gca, 'YScale', 'log');

xticklabels({'Early', 'Middle', 'Late'})
ylim([0.005 1]); yticks([0.01 0.1 1]);
xlabel('Learning Stage')
title('GPe Activity Range')
ylabel('After / Before STN Feedback')
