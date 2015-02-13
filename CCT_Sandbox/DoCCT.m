function [ score ] = DoCCT(trialrow)
%CCT Runs Columbia card task, trial-by-trial
%   Coded by: ELK

global w DIMS CCT COLORS trial_score rects IMAGE fail_list

%Timer stuff
tstart = tic;

%Score stuff
trial_score = 0;

clicked = zeros(DIMS.grid_totes,1);
fail_list = randperm(DIMS.grid_totes,CCT.var(trialrow).LossCards); 
rectcolor = repmat(COLORS.start,1,(DIMS.grid_totes));
rectcolor = [rectcolor COLORS.butt];

%[rectcolor,gameover] = Click4Color(clicked,fail_list);      %chooses color for cards; tests for good/bad flip
Screen('FillRect',w,rectcolor,rects);                       %Draws rectangles.
DoScoreboard();                                             %Displays scores, trial, bads, etc.
%UPDATE NEEDED: This should check trial x block time duration
telap = CountdownClock(tstart,DIMS.trial_dur);    %Runs & displays countdown clock
Screen('Flip',w);

%Display end of trial words stuff - now a constant in main page
%endtext_loc_y = min(rects(2,:))-20;

%next_trial = 0; %using break instead of while w/next_trial
while telap < DIMS.trial_dur;

    [x,y,button] = GetMouse();
    if button(1);
        %test if mouse clicked in one of our precious boxes.
        %This creates arrays of 1s or 0s for > or < min/max dimensions
        xmin = rects(1,:)<=x;
        xmax = rects(3,:)>=x;
        ymin = rects(2,:)<=y;
        ymax = rects(4,:)>=y;
        
        %This tests if there are any cases where all of the above are true.
        clickedonbox = find(xmin & xmax & ymin & ymax);
        
        if ~isempty(clickedonbox);
            if clickedonbox <= DIMS.grid_totes;  
                if clicked(clickedonbox) == 1;
                    %You have already clicked here. Ignore.
                else
                    clicked(clickedonbox) = 1;

                    if ~isempty(fail_list(fail_list == clickedonbox)) %if you clicked on loss
                    %if gameover == 1; %If you have clicked a bad.
                        %BIOPAC PULSE
                        trial_score = trial_score + CCT.var(trialrow).LossAmt;
                        DrawFormattedText(w,'You lose.','center',DIMS.endtext_loc_y,COLORS.RED);
                        %rectcolor = Reveal4Color(fail_list);
                        %Screen('FillRect',w,rectcolor,rects);
                        DoScoreboard();
                        [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                        Screen('Flip',w);
                        WaitSecs(2); % NEEDS CHANGE: to any key.
                        
                        break
                    elseif length(clicked(clicked==1)) == (DIMS.grid_totes - CCT.var(trialrow).LossCards);
                    %elseif gameover ==2; %If you have run out of greens to click.
                        %BIOPAC PULSE
                        trial_score = trial_score + CCT.var(trialrow).GainAmt;
                        DrawFormattedText(w,'You win.','center',DIMS.endtext_loc_y,COLORS.RED);
%                         rectcolor = Reveal4Color(fail_list);
%                         Screen('FillRect',w,rectcolor,rects);
                        [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                        DoScoreboard();
                        Screen('Flip',w);
                        WaitSecs(2); % NEEDS CHANGE: to any key.
                        
                        break
                    else
                        trial_score = trial_score + CCT.var(trialrow).GainAmt);
                        Screen('FillRect',w,rectcolor,rects);
                        [imagerects] = DrawImageRects(clicked);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        telap = CountdownClock(tstart,DIMS.trial_dur);
                        DoScoreboard();
                        
                        Screen('Flip',w);
                    end
                end
            elseif clickedonbox == DIMS.grid_totes+1 %&& ~any(clicked); %End trial button
                %Biopac pulse
                if ~any(clicked)
                    DrawFormattedText(w,'You have selected no clicks. Starting new trial.','center',DIMS.endtext_loc_y,COLORS.RED);
                else
                    DrawFormattedText(w,'Moving to next trial!','center',DIMS.endtext_loc_y,COLORS.RED);
                end
%                 rectcolor = Reveal4Color(fail_list);
%                 Screen('FillRect',w,rectcolor,rects);
                DoScoreboard();
                [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
                Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                Screen('Flip',w);
                WaitSecs(2); % NEEDS CHANGE: to any key.
                
                break
%             elseif clickedonbox == DIMS.grid_totes+2; %Just end it all!
%                 %Biopac pulse
%                 DrawFormattedText(w,'Moving to next trial!','center',DIMS.endtext_loc_y,COLORS.RED);
% %                 rectcolor = Reveal4Color(fail_list);
% %                 Screen('FillRect',w,rectcolor,rects);
%                 DoScoreboard();
%                 [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
%                 Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
%                 Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
%                 Screen('Flip',w);
%                 WaitSecs(2); % NEEDS CHANGE: to any key.
                
%                 break
            end
        end
      
    elseif any(clicked) %no button was pressed recently; just update clock, re-flip everything else
    telap = CountdownClock(tstart,DIMS.trial_dur);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard();
    Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
    Screen('Flip',w);
    
    else %no button ever pressed; updated & reflip everything
    telap = CountdownClock(tstart,DIMS.trial_dur);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard();
    Screen('Flip',w);
    end
    
end

if telap == DIMS.trial_dur;
    
    DrawFormattedText(w,'Time is up.','center',DIMS.endtext_loc_y,COLORS.RED);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard();
    Screen('Flip',w);
    WaitSecs(2);
    %UPDATE NEEDED: Reveal faces here.
end

score = trial_score;
clear clickedonbox change failtest
end

