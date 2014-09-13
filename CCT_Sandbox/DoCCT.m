function [ score ] = DoCCT( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global w DIMS CCT trial YCENTER COLORS

clicked = zeros(DIMS.grid_totes,1);
fail_list = randperm(DIMS.grid_totes,CCT.var.num_bad(trial));
rects = DrawRectsGrid(); %creates parameters for drawing rectangles
[rectcolor,~] = Click4Color(clicked,fail_list); %chooses color for cards; tests for good/bad flip
Screen('FillRect',w,rectcolor,rects); %Draws rectangles.
DoScoreboard(); %Displays scores, trial, bads, etc.
Screen('Flip',w);
next_trial = 0;

while next_trial == 0
    [x,y,button] = GetMouse();
    if button(1);
        %         DrawFormattedText(w,'CLICK','center',YCENTER+150,COLORS.WHITE);
        %         Screen('Flip',w,0,1);
        %test if mouse clicked in one of our precious boxes.
        %This creates arrays of 1s or 0s for > or < min/max dimensions
        xmin = rects(1,:)<=x;
        xmax = rects(3,:)>=x;
        ymin = rects(2,:)<=y;
        ymax = rects(4,:)>=y;
        
        %This tests if there are any cases where all of the above are true.
        clickedonbox = find(xmin & xmax & ymin & ymax);
        
        if ~isempty(clickedonbox);
            clicked(clickedonbox) = 1;
            rects = DrawRectsGrid(); %NEEDS CHANGE: Only needed at start of loop?
            [rectcolor, gameover] = Click4Color(clicked,fail_list);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard();
            Screen('Flip',w);
            if gameover == 1;
                %BIOPAC PULSE
                %score = 0;
                DrawFormattedText(w,'You lose.','center',YCENTER+150,COLORS.RED);
                Screen('FillRect',w,rectcolor,rects);
                DoScoreboard();
                Screen('Flip',w);
                WaitSecs(2); % NEEDS CHANGE: to any key.
                next_trial = 1;
            elseif gameover ==2;
                %BIOPAC PULSE
                %sum score
                DrawFormattedText(w,'You win.','center',YCENTER+150,COLORS.RED);
                Screen('FillRect',w,rectcolor,rects);
                DoScoreboard();
                Screen('Flip',w);
                WaitSecs(2); % NEEDS CHANGE: to any key.
                next_trial = 1;
            end
            %         elseif ~isempty(clicked_button);
            %             %end round, BIOPAC Pulse
        else
        end
%     elseif
        %Test if "end trial" button was pressed.
        %If end trial was pressed, add up score, add to main score, display
        %some text, move to next trial.
    else
    end
    
end

score = 1; %This should calculate based on what happened in trial.

end

