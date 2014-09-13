function [  ] = DoScoreboard( varargin )
%DoDisplayScores Displays stuff on screen.
%   Need to add other stuff here: Trial number, $$$ per good, etc.
%   Probably need to decide how to index locations...use XCENTER
%   YCENTER? or wRect?

global w CCT trial COLORS 

%Base all locations off of some variable to allow proper scaling to
%different screens.
bads_loc_x = 10; 
bads_loc_y = 40;

bads_text = sprintf('Num. of Bads: %d',CCT.var.num_bad(trial));
DrawFormattedText(w,bads_text,bads_loc_x,bads_loc_y,COLORS.WHITE);

end

