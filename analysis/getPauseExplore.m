% Give number of non-instrumental responses with and without coincident pauses 
% All Non-Inst and incorrect Inst were considered as non-instrumental
% behaviors

function [pauseExpl, NpauseExpl] = getPauseExplore (GPes, As, thr, trial); 

n = find(As(:,1)==trial); % time points in the selected trial 
s = As(n,2); % states of that trial 

pauseExpl = 0; NpauseExpl = 0; 

for i = 1:length(n)       
    gpe = GPes(s(i),:,n(i)); 

    if ~isempty(find(gpe <  thr)) % pause occurred
        if (As(n(i),3) ~=1) && (As(n(i),3) ~=3)
            pauseExpl = pauseExpl +1; 
        end

    else % no pause 
        if (As(n(i),3) ~=1) && (As(n(i),3) ~=3)
            NpauseExpl = NpauseExpl +1; 
        end
    end
end 
