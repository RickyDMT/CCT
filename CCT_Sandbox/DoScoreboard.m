function [  ] = DoScoreboard( varargin )
%DoDisplayScores Displays stuff on screen.
%   Need to add other stuff here: Trial number, $$$ per good, etc.
%   Probably need to decide how to index locations...use XCENTER
%   YCENTER? or wRect?

global w wRect CCT trial COLORS trial_score

%Base all locations off of some variable to allow proper scaling to
%different screens.
tscore = trial_score;

left_loc_x = 10;
bads_loc_y = 40;

%Right side of score board -- Uses 'right' & wRect to right justify
scorval_loc_y = 40;
tscore_loc_y = scorval_loc_y + 20;
cumscore_loc_y = tscore_loc_y + 20;

bads_text = sprintf('Num. of Bads: %d',CCT.var.num_bad(trial));

tscore_text = sprintf('Trial Score: %d',tscore);
scorval_text = sprintf('Score per Good: %d',CCT.var.scorval(trial));

if trial == 1; %This should probably calculate across blocks too...?
    cumscore_text = 'Total Score: 0';
else
    cumscore_text = sprintf('Total Score: %d',CCT.data.cumscore(trial-1));
end

%Left Side of scoreboard
DrawFormattedText(w,bads_text,left_loc_x,bads_loc_y,COLORS.WHITE);

%Right side of scoreboard
DrawFormattedText(w,tscore_text,'right',tscore_loc_y,COLORS.WHITE);
DrawFormattedText(w,scorval_text,'right',scorval_loc_y,COLORS.WHITE);
DrawFormattedText(w,cumscore_text,'right',cumscore_loc_y,COLORS.WHITE);

end

