function [ rectcolor] = Reveal4Color(fail_list,varargin )
%Click4Color determines colors for rectangles or some shit, I dunno.
%   Click on a square, it needs to change color. This will help.

global COLORS DIMS


fail = fail_list; %randomly assigned per trial.
%fail = 5; %for testing purposes


rectcolor = repmat(COLORS.good,1,(DIMS.grid_totes)); %+Smiley
rectcolor = [rectcolor COLORS.butt COLORS.butt];
for f = 1:length(fail);
    rectcolor(:,fail(f)) = COLORS.bad; %change to bad color + Unsmiley
end
       

end

