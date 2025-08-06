% return next state based on current state and action for SARSA.m

function [nextState, reward] = environment_wME(state, action, trleng, correctA)

nextState = state + 1; 
reward = 0; 

if state == trleng
    nextState = 1; 
    
elseif state <= 10 % np time-out
    if action == correctA
        nextState = 11; % move to 11        
    elseif action ~= correctA && state == 10
        nextState = 20;        
    end
    
elseif state > 10 && state <= 19 % me time-out
    if  action == 3 % me
        nextState = 20;
        reward = 1; 
    elseif action ~=3 && state == 19
        nextState = 20;        
    end
end

