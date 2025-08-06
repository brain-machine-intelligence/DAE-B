% recursively using sessCut, get block behavioral data 
% blockL : length of the block (i.e. how many sessions) 
% preBlockT, preBlockN: same as preSessN, preSessT but for block start.
% (refer to sessCut.m for preSessN, preSessT, tLimit, RwLimit)

function [sessDurs, Rws, NcorrectAs, NwrongAs, NotherAs, sessTs, sessNs] = blockCut (As, trials, correctA, tLimit, RwLimit, blockL);

sessDurs = []; 
Rws = [];  
NcorrectAs = []; 
NwrongAs = []; 
NotherAs = []; 
sessTs = []; 
sessNs = [];

preSessT = 0; 
preSessN = 0; 

for d = 1: blockL    
    % get data for each session 
    [sessDur, Rw, NcorrectA, NwrongA, NotherA, sessT, sessN] = sessCut (As, trials, preSessT, preSessN, correctA, tLimit, RwLimit);

    sessDurs (d,1) = sessDur; 
    Rws (d,1) = Rw; 
    NcorrectAs (d,1)= NcorrectA; 
    NwrongAs (d,1) = NwrongA; 
    NotherAs (d,1) = NotherA; 
    sessTs (d,1) = sessT; 
    sessNs (d,1) = sessN; 

    % update for the next session 
    preSessT = sessT; 
    preSessN = sessN;     
end 


