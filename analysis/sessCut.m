% cut continuous learning data into day(session)
% preSessT = last trial time of the previous day(session)
% preSessN = last trial N of the previous day(session) + 1 

function [sessDur, Rw, NcorrectA, NwrongA, NotherA, sessT, sessN] = sessCut (As, trials, preSessT, preSessN, correctA, tLimit, RwLimit);

% consider only (right after preSessT ~ until tLimit)
nextAs = As((preSessT+1) : (preSessT+tLimit), :); 

% if the agent failed to obtain RwLimit within tLimit
if sum(nextAs(:,4)) <= RwLimit  
    sessDur = tLimit; 
    sessT = preSessT + sessDur; 

    Rw = sum(nextAs(:,4)); 

    NcorrectA = length (find (nextAs(:,3) == correctA)); 
    NwrongA = length (find (nextAs(:,3) == (3-correctA))); 
    NmeA = length (find (nextAs(:,3) == 3));
    NotherA = sessDur - NcorrectA - NwrongA; 

    % sessN = last trial of the session +1 trial, which is cut in the middle due
    % to tLimit
    sessN = max(find(trials(:,3) < sessT)) + 1; 

    if isempty (sessN) 
        sessN = 1; 
    end

    % next sess starts from the beginning of the (sessN+1)-th trial 
    sessT = trials(sessN, 3); 

else
    Rw = RwLimit; 

    RwTemp = cumsum(nextAs(:,4)); 

    % session ends at RwLimit
    sessT = min(find (RwTemp >= RwLimit)) + preSessT; 
    sessDur = sessT - preSessT; 

    % in this case there is no trial cut in the middle
    sessN = max(find(trials(:,3) == sessT)); 

    AsTemp = As((preSessT+1):sessT, :); 

    NcorrectA = length (find (AsTemp(:,3) == correctA)); 
    NwrongA = length (find (AsTemp(:,3) == (3-correctA))); 
    NmeA = length (find (AsTemp(:,3) == 3)); 
    NotherA = size(AsTemp,1) - NcorrectA - NwrongA - NmeA; 
end 


