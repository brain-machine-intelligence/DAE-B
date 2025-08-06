clear all
tLimit = 1000; RwLimit = 100;
para = [20, 4000, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2];

% number of simulations
k = 100; kstd = sqrt(k)*2; 

behav = []; pvs = []; 

for i = 1:k     
    i % to see simulation progress 

    [y, yraw, pvday] = BGfit(para2, para3, para4, tLimit, RwLimit);
    behav(:,:,i) = y; % col: lnp, rnp, dur, other     
    pvs(:,:,i) = pvday; % col: d, pvnp, pvme, pvother, pvallday    
end

% draw
figure(1);  clf; hold off;
subplot(3,5,1:2); 
shadedErrorBar(1:54, mean(behav(:,1,:),3), std(behav(:,1,:),0,3)/kstd, 'lineProps', '-b'); hold on; 
shadedErrorBar(1:54, mean(behav(:,2,:),3), std(behav(:,2,:),0,3)/kstd, 'lineProps', '-r'); hold on; 
shadedErrorBar(1:54, mean(behav(:,4,:)/7,3), std(behav(:,4,:)/7,0,3)/kstd, 'lineProps', {'-', 'Color', [0.1, 0.8, 0.3]}); hold on; 
ylabel('Behavior Rate'); xlabel('Day');
vline(29, 'k'); vline(46, 'k'); vline(50, 'k'); xlim([1 54]); ylim([0 0.5]);

subplot(3,5,3:4); hold off; 
shadedErrorBar(1:54, mean(behav(:,3,:),3), std(behav(:,3,:),0,3)/kstd, 'lineProps', '-k'); hold on; 
ylabel('Session Duration'); xlabel('Day');
vline(29, 'k'); vline(46, 'k'); vline(50, 'k'); xlim([1 54]); ylim([200 1050]); 

subplot(3,5,6:7); 
shadedErrorBar(1:54, mean(pvs(1:54,2,:),3, 'omitnan'), std(pvs(1:54,2,:),0,3, 'omitnan')/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(1:54, mean(pvs(1:54,3,:),3, 'omitnan'), std(pvs(1:54,3,:),0,3, 'omitnan')/kstd, 'lineProps', '-m'); hold on; 
shadedErrorBar(1:54, mean(pvs(1:54,4,:),3, 'omitnan'), std(pvs(1:54,4,:),0,3, 'omitnan')/kstd, 'lineProps', {'-', 'Color', [0.1, 0.8, 0.3]}); hold on; 
ylabel('Average PV activity'); xlabel('Day');
vline(29, 'k'); vline(46, 'k'); vline(50, 'k'); xlim([1 54]); ylim([0.3, 0.7]); 

subplot(3,5,11:12); 
shadedErrorBar(1:20, mean(pvs(1:20,2,:),3, 'omitnan'), std(pvs(1:20,2,:),0,3, 'omitnan')/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(1:20, mean(pvs(1:20,3,:),3, 'omitnan'), std(pvs(1:20,3,:),0,3, 'omitnan')/kstd, 'lineProps', '-m'); hold on; 
shadedErrorBar(1:20, mean(pvs(1:20,4,:),3, 'omitnan'), std(pvs(1:20,4,:),0,3, 'omitnan')/kstd, 'lineProps', {'-', 'Color', [0.1, 0.8, 0.3]}); hold on; 
ylabel('Average PV activity'); xlabel('Day'); xlim([1 20]); 

subplot(3,5,13:14); 
shadedErrorBar(30:34, mean(pvs(30:34,2,:),3, 'omitnan'), std(pvs(30:34,2,:),0,3, 'omitnan')/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(30:34, mean(pvs(30:34,3,:),3, 'omitnan'), std(pvs(30:34,3,:),0,3, 'omitnan')/kstd, 'lineProps', '-m'); hold on; 
shadedErrorBar(30:34, mean(pvs(30:34,4,:),3, 'omitnan'), std(pvs(30:34,4,:),0,3, 'omitnan')/kstd, 'lineProps', {'-', 'Color', [0.1, 0.8, 0.3]}); hold on; 
xlabel('Day');

subplot(3,5,15); 
shadedErrorBar(47:54, mean(pvs(47:54,2,:),3, 'omitnan'), std(pvs(47:54,2,:),0,3, 'omitnan')/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(47:54, mean(pvs(47:54,3,:),3, 'omitnan'), std(pvs(47:54,3,:),0,3, 'omitnan')/kstd, 'lineProps', '-m'); hold on; 
shadedErrorBar(47:54, mean(pvs(47:54,4,:),3, 'omitnan'), std(pvs(47:54,4,:),0,3, 'omitnan')/kstd, 'lineProps', {'-', 'Color', [0.1, 0.8, 0.3]}); hold on; 
ylabel('Average PV activity'); xlabel('Day'); vline(50, 'k'); xlim([47 54]);


