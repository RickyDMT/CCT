function [ score ] = DoCCT( varargin )
%CCT Runs Columbia card task, trial-by-trial
%   Coded by: ELK

global w DIMS CCT trial YCENTER COLORS trial_score

%Timer stuff
tstart = tic;

%Score stuff
trial_score = 0;

clicked = zeros(DIMS.grid_totes,1);
fail_list = randperm(DIMS.grid_totes,CCT.var.num_bad(trial)); 
rects = DrawRectsGrid();                                    %creates parameters for drawing rectangles
[rectcolor,gameover] = Click4Color(clicked,fail_list);      %chooses color for cards; tests for good/bad flip
Screen('FillRect',w,rectcolor,rects);                       %Draws rectangles.
DoScoreboard();                                             %Displays scores, trial, bads, etc.
telap = CountdownClock(tstart,CCT.var.trial_dur(trial));    %Runs & displays countdown clock
Screen('Flip',w);

%Display end of trial words stuff
endtext_loc_y = min(rects(2,:))-20;

%next_trial = 0; %using break instead of while w/next_trial
while telap < 10;

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
            if clicked(clickedonbox) == 1;
                %You have already clicked here. Ignore.
            else
                clicked(clickedonbox) = 1;
                [rectcolor, gameover] = Click4Color(clicked,fail_list);
                %             Screen('FillRect',w,rectcolor,rects);
                %             telap = CountdownClock(tstart,10);
                %             DoScoreboard();
                %             Screen('Flip',w);
                if gameover == 1; %If you have clicked a bad.
                    %BIOPAC PULSE
                    trial_score = trial_score + CCT.var.lossval;
                    DrawFormattedText(w,'You lose.','center',endtext_loc_y,COLORS.RED);
                    Screen('FillRect',w,rectcolor,rects);
                    DoScoreboard();
                    Screen('Flip',w);
                    WaitSecs(2); % NEEDS CHANGE: to any key.
                    
                    break
                elseif gameover ==2; %If you have run out of greens to click.
                    %BIOPAC PULSE
                    trial_score = trial_score + CCT.var.scorval(trial);
                    DrawFormattedText(w,'You win.','center',endtext_loc_y,COLORS.RED);
                    Screen('FillRect',w,rectcolor,rects);
                    DoScoreboard();
                    Screen('Flip',w);
                    WaitSecs(2); % NEEDS CHANGE: to any key.
                    
                    break
                else
                    trial_score = trial_score + CCT.var.scorval(trial);
                    Screen('FillRect',w,rectcolor,rects);
                    telap = CountdownClock(tstart,CCT.var.trial_dur(trial));
                    DoScoreboard();
                    Screen('Flip',w);
                end
            end
        else %check if "End Button" was pressed.
            %If END Button, end trial, add score, pulse biopac
        end
      
    else %no button was pressed; just update clock, re-flip everything else
    telap = CountdownClock(tstart,CCT.var.trial_dur(trial));
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard();
    Screen('Flip',w);
    end
    
end

if gameover == 0;
    
    DrawFormattedText(w,'Time is up.','center',endtext_loc_y,COLORS.RED);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard();
    Screen('Flip',w);
    WaitSecs(2);
end

score = trial_score;
clear clickedonbox change failtest
end

