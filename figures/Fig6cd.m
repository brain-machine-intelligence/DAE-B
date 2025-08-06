clear all  
tLimit = 500; RwLimit = 100;
para = [20, 6000, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2];  

[trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_trial (para, para2, para3, para4);

% draw Fig 6cd
t = [600, 6000]; 
figure(3); clf % Qp and Qm
subplot(2,4,1); heatmap(Qps(1:19,:,t(1))); title(["dMSN", ['trial ' num2str(t(1))]]);
subplot(2,4,2); heatmap(Qms(1:19,:,t(1))); title("iMSN");
subplot(2,4,3); heatmap(GPes(1:19,:,t(1))); title('GPe');
subplot(2,4,4); heatmap(GPis(1:19,:,t(1))); title('GPi');

subplot(2,4,5); heatmap(Qps(1:19,:,t(2))); title(["dMSN", ['trial ' num2str(t(2))]]);
subplot(2,4,6); heatmap(Qms(1:19,:,t(2))); title('iMSN');
subplot(2,4,7); heatmap(GPes(1:19,:,t(2))); title('GPe');
subplot(2,4,8); heatmap(GPis(1:19,:,t(2))); title('GPi');
