clear all
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 5, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

% Number of simulation
k = 100; kstd = sqrt(k)*2; 

% early, middle, late stages of learning 
etrial = 100; mtrial = 600; ltrial = 1500; 

GPeData = struct(); 
for i = 1:k
    i % to see simulation progress 

    % DAE-B model 
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);
    [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, etrial); 
    GPeData.DAEB.early{i,1} = GPe; 

    [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, mtrial);
    GPeData.DAEB.middle{i,1} = GPe; 

    [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, ltrial); 
    GPeData.DAEB.late{i,1} = GPe; 

    % Model with action-specific connectiivty 
    [trials, As, Qps, Qms, Qs, GPes, GPis] = BG_tStep_topographic (para, para2, para3, para4);    
    [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, etrial); 
    GPeData.topo.early{i,1} = GPe; 

    [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, mtrial);
    GPeData.topo.middle{i,1} = GPe; 

    [GPe, GPi, Qm, Qp] = getTrialLayer (GPes, GPis, Qms, Qps, As, ltrial); 
    GPeData.topo.late{i,1} = GPe; 
end

% get histogram for GPe unit activiy 
GPeDist = struct(); 
stages = {'early', 'middle', 'late'}; 
models = {'DAEB', 'topo'}; 
edges = 0:0.004:0.16; 

for m = 1:length(models)
    m = models{m}; 

    for s = 1:length(stages)
        s = stages{s};

        for i = 1:k
            GPeDist.(m).(s)(i,:) = histcounts(GPeData.(m).(s){i,1}, edges) / numel(GPeData.(m).(s){i,1}); 
        end
    end
end

% draw figure: bar 
figure(4); clf; hold off;  
x = edges(2:end) - min(diff(edges))/2; 

for s = 1:length(stages)
    subplot(3,1,s);
    s = stages{s};
    DAEBm = mean(GPeDist.DAEB.(s));
    DAEBs = std(GPeDist.DAEB.(s))/kstd;

    topom = mean(GPeDist.topo.(s));
    topos = std(GPeDist.topo.(s))/kstd;

    b = bar(x, [DAEBm; topom], 'EdgeColor', 'none'); hold on; 
    b(1).FaceColor = 'k'; 
    b(2).FaceColor = 'm'; 
    barW = b.BarWidth; 

    % Get the x coordinates of the bars
    xc = nan(size([DAEBm; topom]));
    for i = 1:size(xc, 1)
        xc(i,:) = b(i).XEndPoints;
    end

    % Add error bars
    errorbar(xc(1,:), DAEBm, DAEBs, 'k', 'linestyle', 'none', 'LineWidth', 0.25, 'CapSize', barW*3);
    errorbar(xc(2,:), topom, topos, 'm', 'linestyle', 'none', 'LineWidth', 0.25, 'CapSize', barW*3);    
    xticks(edges); 
    xlim([0 0.18]); ylim([0.01 2]);
    set(gca, 'YScale', 'log');     
    ylabel(s); 
    
    if strcmp(s,'early')
        title('% Occurence (Log)'); 
    elseif strcmp(s, 'late')
        xlabel('Unit Activity');
    end    
end

