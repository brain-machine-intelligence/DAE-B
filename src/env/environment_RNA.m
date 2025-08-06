% trleng = 19; 
% 13 is max trial length, 
% 11, 14, 17:stim present, 
% 12, 15, 18: US present, 
% 13, 16, 19: trial end

function [nextState, reward] = environment_RNA (state, action, trialType)

reward = 0; 

if state < 10
    nextState = state + 1;

elseif state == 10 % CS present
    if trialType == 1 % reward
        nextState = state + 1; 
    elseif trialType == 2 % neutral 
        nextState = state + 4; 
    elseif trialType == 3
        nextState = state + 7; % aversive
    end 

elseif ismember(state, [11:13]) % reward type  
    nextState = state + 1;
    if action == 1 && state == 11 % lick during cue 
        reward = 0.5;        
    elseif action == 1 && state == 12 % lick during outcome 
        reward = 1; 
    end

elseif ismember(state, [14:16]) % neutral type 
    nextState = state + 1;

elseif ismember(state, [17:19]) % averisve type 
    nextState = state + 1;
    if state ~= 18
        reward = 0;
    else % state == 18 averisve US delivery 
        if action == 2 % blink
            reward = 0; 
        else
            reward = -1;
        end
    end
end 


