function [  ] = DoScoreboard(trialrow, losscards, lossamt, gainamt, tscore, varargin )
%DoDisplayScores Displays stuff on screen.
%   Need to add other stuff here: Trial number, $$$ per good, etc.
%   Probably need to decide how to index locations...use XCENTER
%   YCENTER? or wRect?

global w rects CCT COLORS wRect

%Base all locations off of some variable to allow proper scaling to
%different screens.
% Screen('FillRect',w,COLORS.WHITE,rects);

oldsize = Screen('TextSize',w,20);
% tscore = trial_score;

lossa_loc_x = fix(wRect(3)*.05);
gaina_loc_x = fix(wRect(3)/2);                %Use CenterTextonPoint: This value represents middle coordinate of text box
lossc_loc_x = fix((wRect(3)*(9/10))-200);      %Write text that ends at 10% border on right side of screen, ASSUMES 100 pixel length

botrow_y = rects(2,end) - 30;
toprow_y = botrow_y - 28;
% left_loc_x = 10;
% bads_loc_y = 40;
% loss_loc_y = bads_loc_y +20;

%Right side of score board -- Uses 'right' & wRect to right justify
% scorval_loc_y = 40;
% tscore_loc_y = scorval_loc_y + 20;


%Button text locations
% nocard_x = rects(1,length(rects)-1) + 50;
% nocard_y = rects(2,length(rects)-1) + 12;
stop_x = rects(1,length(rects))+50;
stop_y = rects(2,length(rects))+12;

lossc_text = sprintf('Num. of Loss Cards: %d',losscards);%CCT.var(trialrow).LossCards);
lossa_text = sprintf('Loss Amount: %d',lossamt);%CCT.var(trialrow).LossAmt);
gaina_text = sprintf('Gain Amount: %d',gainamt);%CCT.var(trialrow).GainAmt);


tscore_text = sprintf('Trial Score: %d',tscore);
if trialrow == 0;
    trial_text = 'Trial: Example';
else
    trial_text = sprintf('Trial: %d',CCT.var(trialrow).Trial);
end

% if trial == 1; 
%     cumscore_text = 'Total Score: 0        ';
% else
%     cumscore_text = sprintf('Total Score: %d        ',CCT.data.cumscore(trial-1));
% end

%Bottomw Row of scoreboard
DrawFormattedText(w,lossc_text,lossc_loc_x,botrow_y,COLORS.WHITE);
DrawFormattedText(w,lossa_text,lossa_loc_x,botrow_y,COLORS.WHITE);
CenterTextOnPoint(w,gaina_text,gaina_loc_x,botrow_y+10,COLORS.WHITE);

%Top Row of scoreboard
DrawFormattedText(w,tscore_text,lossc_loc_x,toprow_y,COLORS.WHITE);
DrawFormattedText(w,trial_text,lossa_loc_x,toprow_y,COLORS.WHITE);


%Button text

if nargin == 6;
    DrawFormattedText(w,'Next Trial','center',rects(2,end)+2,COLORS.BLACK);
else
    DrawFormattedText(w,'STOP!','center',rects(2,end)+2,COLORS.BLACK);
end


Screen('TextSize',w,oldsize);

% Screen('Flip',w);

end

