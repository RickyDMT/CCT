function [ rectcolor,gameover] = Click4Color( clicked,fail_list,varargin )
%Click4Color determines colors for rectangles or some shit, I dunno.
%   Click on a square, it needs to change color. This will help.

global COLORS DIMS CCT trial

% start = COLORS.BLUE';
% good = COLORS.GREEN';
% bad = COLORS.RED';
% butt = COLORS.YELLOW';

fail = fail_list; %randomly assigned per trial.
%fail = 5; %for testing purposes
gameover = 0;

rectcolor = repmat(COLORS.start,1,(DIMS.grid_totes));
rectcolor = [rectcolor COLORS.butt COLORS.butt];

change = find(clicked);
if ~isempty(change)
    for z = 1:length(change);
        failtest = (change(z) == fail);
        if any(failtest);
            %rectcolor(:,change(z)) = COLORS.bad; %Unnecessary now: Taken
            %care of in Reveal4Color.
            gameover = 1;
        else
            rectcolor(:,change(z)) = COLORS.good;
            if length(change) == (DIMS.grid_totes - CCT.var.num_bad(trial));
                gameover = 2;
            end
        end
    end
       
end

end

