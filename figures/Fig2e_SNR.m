clear all 
tLimit = 1000; RwLimit = 100;
para = [20, 1600, 1, 10, 100, 0.01];
para2 = [0.001, 0.001, 0.9, 0.9, 0.1, -0.2];
para3 = [0.9, 1.1, 4, 1, 0.0005, 1]; 
para4 = [0.9, 0.5, 0.1, 2]; 

models = {'DAEB', 'topo'}; 
stages = {'early', 'middle', 'late'}; 
strials = [100 600 1500];

% Number of simulation
k = 100; kstd = sqrt(k)*2; 

% outputs and output initialize
aftGPeData = struct(); befGPeData = struct(); 
for m = 1:2
    model = models{m};
    for s = 1:3
        stage = stages{s};
        for i = 1:k
            aftGPeData.(model).(stage) = [];
            befGPeData.(model).(stage) = [];
        end        
    end
end   

% simulate GPe activity before and after GPe-STN loop
for i = 1:k
    i % to see simulation progress 

    % DAE-B model
    [trials, As, Qps, Qms, Qs, PVs, GPes, GPis] = BG_tStep (para, para2, para3, para4);
    for s = 1:3
        stage = stages{s};
        strial = strials(s);
        % get GPe activty after GPe-STN loop 
        aftGPeData.DAEB.(stage) = [aftGPeData.DAEB.(stage); GPes(1,:,min(find(As(:,1)==strial)))];
        
        % get GPe activty before GPe-STN loop 
        Qm = Qms(1,:,min(find(As(:,1)==strial))); 
        [preGPe] = getPreGPeActivity (Qm, para3, para4); 
        befGPeData.DAEB.(stage) = [befGPeData.DAEB.(stage); preGPe];
    end

    % Model with action-specific connectiivty 
    [trials, As, Qps, Qms, Qs, GPes, GPis] = BG_tStep_topographic (para, para2, para3, para4);    
    for s = 1:3
        stage = stages{s};
        strial = strials(s);
        % get GPe activty after GPe-STN loop 
        aftGPeData.topo.(stage) = [aftGPeData.topo.(stage); GPes(1,:,min(find(As(:,1)==strial)))];

        % get GPe activty before GPe-STN loop 
        Qm = Qms(1,:,min(find(As(:,1)==strial))); 
        [preGPe] = getPreGPeActivity (Qm, para3, para4); 
        befGPeData.topo.(stage) = [befGPeData.topo.(stage); preGPe];        
    end
end

% compute SNR
StoN = struct(); StoN2 = struct();
for ss = 1:3
    stage = stages{ss};

    for m = 1:2
        model = models{m};
        
        % before GPe-STN circuit
        befGPe = befGPeData.(model).(stage);
        [s, n, snr] = getSNR (befGPe, 1);
        StoN.(model).signal(ss,1) = s;
        StoN.(model).noise(ss,1) = n;
        StoN.(model).snr(ss,1) = snr;

        [s, n, snr] = getSNR (befGPe, 2);
        StoN2.(model).signal(ss,1) = s;
        StoN2.(model).noise(ss,1) = n;
        StoN2.(model).snr(ss,1) = snr;

        % after GPe-STN circuit
        aftGPe = aftGPeData.(model).(stage);
        [s, n, snr] = getSNR (aftGPe, 1);
        StoN.(model).signal(ss,2) = s;
        StoN.(model).noise(ss,2) = n;
        StoN.(model).snr(ss,2) = snr;

        [s, n, snr] = getSNR (aftGPe, 2);
        StoN2.(model).signal(ss,2) = s;
        StoN2.(model).noise(ss,2) = n;
        StoN2.(model).snr(ss,2) = snr;
    end
end 

temp1 = StoN.DAEB.snr(:,2) ./ StoN.DAEB.snr(:,1); 
temp2 = StoN.topo.snr(:,2) ./ StoN.topo.snr(:,1); 
y1 = [temp1'; temp2']; 

temp1 = StoN2.DAEB.snr(:,2) ./ StoN2.DAEB.snr(:,1); 
temp2 = StoN2.topo.snr(:,2) ./ StoN2.topo.snr(:,1); 
y2 = [temp1'; temp2']; 


%% draw figure: snr type 1
figure(3); clf; hold off; subplot(1,2,1); 
x = [1:3];

b = bar(x,y1, 'EdgeColor', 'none'); 
b(1).FaceColor = 'k'; 
b(2).FaceColor = 'm'; hold on; 
xticklabels({'Early', 'Middle', 'Late'}); 
title('Signal-to-Noise Ratio'); ylabel("After / Before STN Feedback")
set(gca, 'YScale', 'log'); ylim([0.5 50]);
xlabel("Learning Stage"); 

%% draw figure: snr type 2
subplot(1,2,2); 

b = bar(x,y2, 'EdgeColor', 'none'); 
b(1).FaceColor = 'k'; 
b(2).FaceColor = 'm'; hold on; 
xticklabels({'Early', 'Middle', 'Late'}); 
title('Signal / Noise'); ylabel("After / Before STN Feedback")
set(gca, 'YScale', 'log');  ylim([0.5 50]); 
xlabel("Learning Stage");
