function [  ] = DoScoreboard( varargin )
%DoDisplayScores Displays stuff on screen.
%   Need to add other stuff here: Trial number, $$$ per good, etc.
%   Probably need to decide how to index locations...use XCENTER
%   YCENTER? or wRect?

global w rects CCT trial COLORS trial_score

%Base all locations off of some variable to allow proper scaling to
%different screens.
tscore = trial_score;

left_loc_x = 10;
bads_loc_y = 40;
loss_loc_y = bads_loc_y +20;

%Right side of score board -- Uses 'right' & wRect to right justify
scorval_loc_y = 40;
tscore_loc_y = scorval_loc_y + 20;
cumscore_loc_y = tscore_loc_y + 20;

%Button text locations
nocard_x = rects(1,length(rects)-1) + 50;
nocard_y = rects(2,length(rects)-1) + 12;
stop_x = rects(1,length(rects))+50;
stop_y = rects(2,length(rects))+12;


bads_text = sprintf('Num. of Loss Cards: %d',CCT.var.num_bad(trial));
loss_text = sprintf('Loss Amount: %d',CCT.var.lossval(trial));

tscore_text = sprintf('Trial Score: %d        ',tscore);
scorval_text = sprintf('Gain Amount: %d        ',CCT.var.scorval(trial));

if trial == 1; 
    cumscore_text = 'Total Score: 0        ';
else
    cumscore_text = sprintf('Total Score: %d        ',CCT.data.cumscore(trial-1));
end

%Left Side of scoreboard
DrawFormattedText(w,bads_text,left_loc_x,bads_loc_y,COLORS.WHITE);
DrawFormattedText(w,loss_text,left_loc_x,loss_loc_y,COLORS.WHITE);

%Right side of scoreboard
DrawFormattedText(w,tscore_text,'right',tscore_loc_y,COLORS.WHITE);
DrawFormattedText(w,scorval_text,'right',scorval_loc_y,COLORS.WHITE);
DrawFormattedText(w,cumscore_text,'right',cumscore_loc_y,COLORS.WHITE);

%Button text
oldsize = Screen('TextSize',w,10);
CenterTextOnPoint(w,'No cards',nocard_x,nocard_y,COLORS.BLACK);
CenterTextOnPoint(w,'STOP/Turn Over',stop_x,stop_y,COLORS.BLACK);
Screen('TextSize',w,oldsize);

end

