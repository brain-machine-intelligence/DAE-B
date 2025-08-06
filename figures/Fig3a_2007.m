clear all
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

% activity threshold for pause and pause rate theshold for pauser 
thr = 0.01; pauserThr = 0.5; 

% Number of simulation
k = 100; kstd = sqrt(k)*2; 

% early, middle, late learning stages 
early = []; late = []; middle = []; 
etrial = 100; mtrial = 600; ltrial = 1500;

for i = 1:k
    % get early pause cells 
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);
    [pauserR] = getPauser (GPes, As, trials, thr, etrial, pauserThr, para); 
    enInst = getInstBehav (As, etrial); 
    early(i,:) = [pauserR, enInst]; 

    % get middle pause cells 
    [pauserR] = getPauser (GPes, As, trials, thr, mtrial, pauserThr, para); 
    mnInst = getInstBehav (As, mtrial); 
    middle(i,:) = [pauserR, mnInst]; 

    % get late pause cells 
    [pauserR] = getPauser (GPes, As, trials, thr, ltrial, pauserThr, para); 
    lnInst = getInstBehav (As, ltrial); 
    late(i,:) = [pauserR, lnInst]; 
    i
end
save ('fig2007_ori.mat', 'early', 'middle', 'late', 'para', 'para2', 'para3', 'para4', 'tLimit', 'RwLimit'); 

% save data for Page's trend test in R 
prate = [early(:,1) middle(:,1) late(:,1)]; csvwrite('prate.csv', prate); 
irate = [early(:,2) middle(:,2) late(:,2)]; csvwrite('irate.csv', irate); 

% draw fig
figure(3); clf; hold off; kstd = sqrt(length(early))*2; 
subplot(1,2,1); 
x = [1:3];
y = [mean(early); mean(middle); mean(late)];
b = bar(x,y); 
b(1).FaceColor = 'k'; 
b(2).FaceColor = 'w'; hold on; 
barW = b.BarWidth; 
xticklabels({'Early', 'Middle', 'Late'}); 
ylabel('Ratio, Rate')
ylim([0 1]);  yticks([0:5]/5);

% Get the x coordinates of the bars
x = nan(size(y)); 
for i = 1:size(y, 2)
    x(:,i) = b(i).XEndPoints;
end

% Add error bars
errorbar(x(1, :), mean(early), std(early)/kstd, 'k', 'linestyle', 'none', 'LineWidth', 0.25, 'CapSize', barW*3);
errorbar(x(2, :), mean(middle), std(middle)/kstd, 'k', 'linestyle', 'none', 'LineWidth', 0.25, 'CapSize', barW*3);
errorbar(x(3, :), mean(late), std(late)/kstd, 'k', 'linestyle', 'none', 'LineWidth', 0.25, 'CapSize', barW*3);

