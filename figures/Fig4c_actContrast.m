clear all; 
tLimit = 1000; RwLimit = 100;
para = [20, 1700, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

pvX = 1500; pvN = 1.5; %  GPe-to-STN projection was artificially increased by 1.5 times since trial 1500 onward
t = (pvX-100):(pvX+100); 

k = 100; % number of simulations 

gpecont = {}; gpicont = {}; CorrectA = 1; 
pvfs = [0.9, 0.5];  % compare the effect of increasing GPe-to-STN projection when W_GPe_to_STN is 0.9 versus 0.5

for j = 1:length(pvfs)
    para3(1) = pvfs(j)

    gpecont{j,1} = zeros(k, length(t));
    gpicont{j,1} = zeros(k, length(t));   

    for i = 1:k
        [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BGpv (para, para2, para3, para4, pvX, pvN);

        for trial = t(1):t(end)
            gpecont{j,1}(i,trial-t(1)+1) = getActContrastGp(GPes, trial, CorrectA); 
            gpicont{j,1}(i,trial-t(1)+1) = getActContrastGp(GPis, trial, CorrectA); 
        end 
    end
end

kstd = sqrt(k)*2; 
figure(1); clf; hold off;  subplot(1,2,1); 
shadedErrorBar(t, mean(gpecont{1,1}), std(gpecont{1,1})/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(t, mean(gpecont{2,1}), std(gpecont{2,1})/kstd, 'lineProps', {'-', 'Color', [0.6,0.6,0.6]} ); hold on; 
xlabel('Trial'); ylabel('Activity Contrast Contrast (Correct - mean(Other))'); title('Effect of ProtoGPe-STN activity increase GPe'); 
xlim([t(1) t(end)]); ylim([-0.5 0.1]); vline(1500); 

subplot(1,2,2);
shadedErrorBar(t, mean(gpicont{1,1}), std(gpicont{1,1})/kstd, 'lineProps', '-k'); hold on; 
shadedErrorBar(t, mean(gpicont{2,1}), std(gpicont{2,1})/kstd, 'lineProps', {'-', 'Color', [0.6,0.6,0.6]} ); hold on; 
xlabel('Trial'); ylabel('Activity Contrast Coontrast (Correct - mean(Other))'); title('GPi'); 
xlim([t(1) t(end)]); ylim([-0.1 1.5]); vline(1500); 
