clear all 
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 
thr = 0.01; % activity threshold for pause

% early, middle, late stage
etrial = 100; mtrial = 600; ltrial = 1500; 

% Number of simulation
k = 100; kstd = sqrt(k)*2; 

% output
early = []; late = []; middle = []; 

%% para3(1) for suppl fig 5. 
% t = [0.37 0.44 0.51 0.59 0.66];

for w = 1:5    
    para3(1) = 0.4 + 0.1 * w; 
    % para3(1) = t(w); 
    w % to see simulation progress 

    for i = 1:k        
        [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4); 

        % early             
        [epause, ipause] = getPauseCells (GPes, GPis, As, trials, thr, etrial);
        early(i,:, w) = [epause, ipause]; % 190 comes from actionN * states (excluding rewarding state)

        % middle 
        [epause, ipause] = getPauseCells (GPes, GPis, As, trials, thr, mtrial);
        middle(i,:, w) = [epause, ipause]; 

        % late 
        [epause, ipause] = getPauseCells (GPes, GPis, As, trials, thr, ltrial);
        late(i,:, w) = [epause, ipause]; 
    end
end 

figure(1); clf; hold off; 
t = [0.5 0.6 0.7 0.8 0.9]; 
% t = [0.37 0.44 0.51 0.59 0.66];

subplot(1,2,1); 
shadedErrorBar(t, mean(early(:,1,:), 1), std(early(:,1,:), 0, 1)/kstd, 'lineProps', {'-', 'Color', [0,0,0]} ); hold on; 
shadedErrorBar(t, mean(early(:,2,:), 1), std(early(:,2,:), 0, 1)/kstd, 'lineProps', {'-', 'Color', [0.5,0.5,0.5]} ); hold on; 
xlabel('WGPe-STN'); ylabel('Pause #'); 
ylim([-10 100]); yticks([-10 0 50 100]);
% ylim([-10 100]); yticks([-10 0 50 100]); xlim([0.37 0.66]); xticks(t);

subplot(1,2,2); 
shadedErrorBar(t, mean(late(:,1,:), 1), std(late(:,1,:), 0, 1)/kstd, 'lineProps', {'-', 'Color', [0 0 0]} ); hold on; 
shadedErrorBar(t, mean(late(:,2,:), 1), std(late(:,2,:), 0, 1)/kstd, 'lineProps', {'-', 'Color', [0.5 0.5 0.5]} ); hold on; 
xlabel('WGPe-STN'); ylabel('Pause #'); 
ylim([-10 100]); yticks([-10 0 50 100]); 
% ylim([-10 100]); yticks([-10 0 50 100]); xlim([0.37 0.66]); xticks(t);

