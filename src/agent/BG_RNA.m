%% Modified from BG_tStep to simulate experimental paradigm in fig 3b

% para = [trleng numTrial correctA actionN ini]; 
% trleng = max length of a trial (refer to Fig.1C left)
% numTrial = # of trials to simulate
% correctA = correct Inst Response. Either 1 or 2 (refer to Fig.1C right)
% actionN = total % of actions (refer to Fig.1C right)
% ini = used for Striatum initialization. e.g. Qp = STRc + rand(trleng, actionN)/ini;

% para2 = [alpha beta gamma lambda softm effortR]; 

% para3 = [pvf, gpef, gpif, pvf2, pvf3, pvf4]; 
% pvf = W_GPe_to_STN 
% gpef = W_STN_to_GPe
% gpif = W_STN_to_GPi
% pvf3 = Inc_Decay (refer to equation 11)
% pvf2 and pvf4 are for reversal and were fixed to 1 in all simulations

% para4 = [GPc, STNc, STRc, eiC]; 
% GPc = baseline activity for the GP (similar to STNc) but were not used
% STNc = baseline activity for the STN (refer to equation 1)
% STRc = Initial baseline activity of the striatum 
% eiC = W_GPe_to_GPi


function [trials, As, Qps, Qms, STNs, Qs, PVs, GPes, GPis] = BG_RNA (para, para2, para3, para4)

% Experimental setup
trleng = para(1); 
numTrial = para(2); % numTrial
correctA = para(3); % correct NP
actionN = para(4); % number of actions: LNP, RNP, ME, NonInst's
ini = para(5); 

% Set hyperparameters
alpha = para2(1); % learning rate for Qp
beta = para2(2); % learning rate for Qm 
gamma = para2(3); % discount factor
lambda = para2(4); % el trace decay rate
softm = para2(5); 
effortR = para2(6); 

pvf = para3(1); 
gpef = para3(2); 
gpif = para3(3);
pvf2 = para3(4);  % pv = pvf2 - pvf3 * n^pvf4; % for reversal only 
pvf3 = para3(5); 
pvf4 = para3(6); 

% Set activation function 
GPc = para4(1); 
STNc = para4(2); 
STRc = para4(3); 
eiC = para4(4); 

% Initialize striatum 
Qp = STRc + rand(trleng, actionN)/ini;
Qm = STRc + rand(trleng, actionN)/ini; 

% Compute Q for the first trial
GPe = STNc * gpef - Qm ; 
GPe = neuronActFtn(GPe,1); 
pv = mean(GPe')';  % mean across actions

Cortex = 0; 
STN = STNc + Cortex - pv*pvf; 
STN = neuronActFtn(STN,1); 

GPe = - Qm + STN*gpef; 
GPe = neuronActFtn(GPe,1); 

GPi = - Qp - GPe*eiC + STN*gpif; 
GPi = neuronActFtn(GPi,1); 
Q = 1-GPi;

% define output variables 
Qps = zeros(trleng, actionN, 1); 
Qms = zeros(trleng, actionN, 1); 
Qs = zeros(trleng, actionN, 1); 
GPes = []; 
GPis = []; 
PVs = NaN(numTrial, trleng); 
As = []; % As = [tStep since block start(n), state, action, reward, pe] 
trials = []; % [trial(z), trial length(t), tStep since block start(n), reward] 

%  Initialize
el = zeros(trleng, actionN);
n = 1; % count time step from the start of the block.


% Loop over trials
for z = 1:numTrial    

    % Reset for a new trial  
    t = 1; % time step within each trial to measure trial length    
    state = 1;  
    el(:) = 0;  % eligibility trace       

    % set trial type: reward, neutral, aversive
    trialType = randi(3); 
 
    % Choose next action using softmax 
    action = chooseAction(Q, state, softm);    

    % Loop over time steps within trial
    while state <= trleng      
        Qps(:,:,n) = Qp;
        Qms(:,:,n) = Qm;
        PVs(z, state) = pv(state); 
        STNs(z, state) = STN(state); 
        GPes(:,:,n) = GPe;
        GPis(:,:,n) = GPi;
        Qs(:,:,n) = Q;
        
        % State transition function
        [nextState, reward] = environment_RNA (state, action, trialType);

        % cost of behavior                                                
        effort = effortR; 
        
        % Choose next action using softmax
        nextAction = chooseAction(Q, nextState, softm);              
                
        % Compute TD error and update Striatum which receives DA proj.
        Qtemp = Qp - Qm; 
        pe = reward + effort + gamma*Qtemp(nextState, nextAction) - Qtemp(state, action);
        el(state, action) = el(state, action) + 1;

        Qp = Qp + alpha*pe*el;
        Qm = Qm + beta*(-pe)*el;
        Qp = neuronActFtn(Qp,1);
        Qm = neuronActFtn(Qm,1);     

        % save for analyses
        As(n,:) = [z, state, action, reward, pe];
        trials(z,:) = [z t n reward trialType];                 

        % STN GPe GPi circuit
        GPe = STNc * gpef - Qm;
        GPe = neuronActFtn(GPe,1);
        pv = mean(GPe')';  % mean across actions   

        Cortex = 0;         
        STN = STNc + Cortex - pv* pvf; 
        STN = neuronActFtn(STN,1);

        GPe = - Qm + STN*gpef;
        GPe = neuronActFtn(GPe,1);

        GPi = - Qp - GPe*eiC + STN*gpif;
        GPi = neuronActFtn(GPi, 1);

        Q = 1-GPi;            

        % Update state, action and el
        n = n+1;
        t = t+1;  
        state = nextState;
        action = nextAction;
        el = lambda*el;    

        if ismember(nextState, [13, 16, 19]) % timeout or rewarded                        
            break;
        end                    
    end   
end

