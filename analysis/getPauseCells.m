% give the number of pausing GP units durinig the specified trial
% pause is defined as activity less than 'thr'

function [epause, ipause] = getPauseCells (GPes, GPis, As, trials, thr, trial); 

n = find(As(:,1)==trial); % time points in the selected trial 

if ~isempty(n)
    s = As(n,2); % states of that trial

    epause = 0;
    ipause = 0;
    for i = 1:length(n)
        gpe = GPes(s(i),:,n(i));
        epause = epause + length(find(gpe <  thr));

        gpi = GPis(s(i),:,n(i));
        ipause = ipause + length(find(gpi <  thr));
    end

else
    error('ErrorMessage');
end




