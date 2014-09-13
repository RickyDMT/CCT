function [ rectcolor,gameover] = Click4Color( clicked,fail_list,varargin )
%Click4Color determines colors for rectangles or some shit, I dunno.
%   Click on a square, it needs to change color. This will help.

global COLORS DIMS CCT trial

start = COLORS.BLUE';
good = COLORS.GREEN';
bad = COLORS.RED';
fail = fail_list; %randomly assigned per trial.
%fail = 5; %for testing purposes
gameover = 0;

rectcolor = repmat(start,1,(DIMS.grid_totes));
change = find(clicked);
if ~isempty(change)
    for z = 1:length(change);
        failtest = change(z) == fail;
        if any(failtest);
            rectcolor(:,change(z)) = bad; %change to bad color
            gameover = 1;
        else
            rectcolor(:,change(z)) = good;
            if length(change) == (DIMS.grid_totes-CCT.var.num_bad(trial));
                gameover = 2;
            end
        end
    end
       
end

end

