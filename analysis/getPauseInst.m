% give number of correct instrumental responses with and without coincident pauses 

function [pauseInst, NpauseInst] = getPauseInst (GPes, As, thr, trial); 

n = find(As(:,1)==trial); % time points in the selected trial 
s = As(n,2); % states of that trial 

pauseInst = 0; NpauseInst = 0; 

for i = 1:length(n)       
    gpe = GPes(s(i),:,n(i)); 

    if ~isempty(find(gpe <  thr)) % pause occurred
        if (As(n(i),3) ==1) || (As(n(i),3) ==3)
            pauseInst = pauseInst +1; 
        end

    else % no pause 
        if (As(n(i),3) ==1) || (As(n(i),3) ==3)
            NpauseInst = NpauseInst +1; 
        end
    end
end 
