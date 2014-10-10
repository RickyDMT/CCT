function [ selected ] = RandomTrialSelector( varargin )
%RandomTrialSelector Selects random trials to play out.
%   Input trial score output, have participant click 3x for random
%   selection.

global w wRect COLORS KEY

%Where should random numbers be displayed? What size?
numsq_side = 75;
numsq_y1 = repmat(fix(wRect(4)/3),1,3);
numsq_y2 = numsq_y1 + numsq_side;
numsq_texty = numsq_y1 + numsq_side/2;
numsq_textx = [fix(wRect(3)/4) fix(wRect(3)/2) fix(wRect(3)*(3/4))];
numsq_x1 = numsq_textx - (numsq_side/2);
numsq_x2 = numsq_x1 + numsq_side;

squares4nums = [numsq_x1; numsq_y1; numsq_x2; numsq_y2];


while 1
    selected = randperm(STIM.trials,3);
    s1 = sprintf('%d',selected(1));
    s2 = sprintf('%d',selected(2));
    s3 = sprintf('%d',selected(3));
    Screen('FillRect',w,COLORS.WHITE,squares4nums);
    Screen('TextSize',w,60);
    CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.RED);
    CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.RED);
    CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.RED);
    Screen('TextSize',w,20);
    DrawFormattedText(w,'Press the space bar\n to choose trials to payout!','center',wRect(4)/8,COLORS.WHITE);
    
    Screen('Flip',w);
    
    [Down, ~, Code] = KbCheck();
        if Down == 1 && find(Code) == KEY.select;
           
            break;
        end
end
Screen('FillRect',w,COLORS.WHITE,squares4nums);
oldtextsize = Screen('TextSize',w,60);
CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.BLACK);
CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.BLACK);
CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.BLACK);
Screen('TextSize',w,oldtextsize);
DrawFormattedText(w,'You have selected the following trials.\nPlease wait while payout is calculated.','center',wRect(4)/8,COLORS.WHITE);

Screen('Flip',w);
KbWait();
    
end

