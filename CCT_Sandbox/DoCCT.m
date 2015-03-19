function [ score, outcome, boxes, time_left,rt_first ] = DoCCT(trialrow)
%CCT Runs Columbia card task, trial-by-trial
%   Coded by: ELK

global w DIMS CCT COLORS trial_score rects IMAGE fail_list



%Score stuff
trial_score = 0;
if trialrow==0;
   GainAmt = STIM.gainamt(randi(2,1));
   LossCards = STIM.lossc(randi(2,1));
   LossAmt = STIM.lossamt(randi(2,1));
else
    GainAmt= CCT.var(trialrow).GainAmt;
    LossCards = CCT.var(trialrow).LossCards;
    LossAmt = CCT.var(trialrow).LossAmt;
end    
clicked = zeros(DIMS.grid_totes,1);
fail_list = randperm(DIMS.grid_totes,LossCards); 
rectcolor = repmat(COLORS.start,1,(DIMS.grid_totes));
rectcolor = [rectcolor COLORS.butt];

%[rectcolor,gameover] = Click4Color(clicked,fail_list);      %chooses color for cards; tests for good/bad flip
Screen('FillRect',w,rectcolor,rects);                       %Draws rectangles.
DoScoreboard(trialrow);                                             %Displays scores, trial, bads, etc.

%Timer stuff
tstart = tic;
telap = CountdownClock(tstart,DIMS.trial_dur,rects);    %Runs & displays countdown clock
Screen('Flip',w);

%Display end of trial words stuff - now a constant in main page
%endtext_loc_y = min(rects(2,:))-20;

%next_trial = 0; %using break instead of while w/next_trial
while telap < DIMS.trial_dur;
    button = 0;
    
    [~,~,buttons] = GetMouse();
    while any(buttons) && telap < DIMS.trial_dur % if already down, wait for release
        [~,~,buttons] = GetMouse();
        if any(clicked)
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow);
            Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
            Screen('Flip',w);
            
        else %no button ever pressed; updated & reflip everything
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow);
            Screen('Flip',w);
        end

    end
    
    while ~any(buttons) && telap < DIMS.trial_dur % wait for press
        [~,~,buttons] = GetMouse();
        if any(clicked)
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow);
            Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
            Screen('Flip',w);
            
        else %no button ever pressed; updated & reflip everything
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow);
            Screen('Flip',w);
        end
    end
    
    while any(buttons) && telap < DIMS.trial_dur % wait for release
        button = 1;
        [x,y,buttons] = GetMouse();
        if any(clicked)
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow);
            Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
            Screen('Flip',w);
            
        else %no button ever pressed; updated & reflip everything
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow);
            Screen('Flip',w);
        end
    end
    
    if button(1);
        clicktime = toc(tstart);
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
                        %BIOPAC PULSE
%                         outp(4);
%                         WaitSecs(.05);
                        trial_score = trial_score + LossAmt;
                        
                        %XXX UPDATE YOU LOSE LOCATION.
                        DrawFormattedText(w,'You lose.','center',rects(2,end)+45,COLORS.RED);
                        %rectcolor = Reveal4Color(fail_list);
                        %Screen('FillRect',w,rectcolor,rects);
                        DoScoreboard(trialrow);
                        [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                        Screen('Flip',w);
                        outcome = 0;
                        time_left = DIMS.trial_dur - (clicktime);
                        if length(find(clicked)) == 1;
                            rt_first = clicktime;
                        end
                        WaitSecs(2); % XXX Have subj click on button to continue.
                        
                        break
                    elseif length(clicked(clicked==1)) == (DIMS.grid_totes - LossCards);
                        %BIOPAC PULSE
%                         outp(8);
%                         WaitSecs(.05);

                        trial_score = trial_score + GainAmt;
                        DrawFormattedText(w,'You win.','center',rects(2,end)+45,COLORS.RED);

%                         rectcolor = Reveal4Color(fail_list);
%                         Screen('FillRect',w,rectcolor,rects);
                        [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                        DoScoreboard(trialrow);
                        Screen('Flip',w);
                        outcome = 1;
                        time_left = DIMS.trial_dur - (clicktime);
                        WaitSecs(2); % XXX Have subj click on button to continue.
                        
                        break
                    else
                        %BioPacPulse
%                         outp(2);
%                         WaitSecs(.05);
                        trial_score = trial_score + GainAmt;
                        Screen('FillRect',w,rectcolor,rects);
                        [imagerects] = DrawImageRects(clicked);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        telap = CountdownClock(tstart,DIMS.trial_dur,rects);
                        DoScoreboard(trialrow);
                        Screen('Flip',w);
                        
                        if length(find(clicked)) == 1;
                            rt_first = clicktime;
                        end
                        
                    end
                end
            elseif clickedonbox == DIMS.grid_totes+1 %End trial button
                %Biopac pulse
%                 outp(16);
%                 WaitSecs(.05);
                
                if ~any(clicked)
                    DrawFormattedText(w,'You have selected no cards. Starting new trial.','center',rects(2,end)+45,COLORS.RED);
                    rt_first = NaN;
                else
                    DrawFormattedText(w,'Moving to next trial!','center',rects(2,end)+45,COLORS.RED);
                end
%                 rectcolor = Reveal4Color(fail_list);
%                 Screen('FillRect',w,rectcolor,rects);
                DoScoreboard(trialrow);
                [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
                Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                Screen('Flip',w);
                outcome = 2;
                time_left = DIMS.trial_dur - (clicktime);
                WaitSecs(2); % XXX Have subj click on button to continue.
                
                break
            end
        end
    end
      
    if any(clicked) %no button was pressed recently; just update clock, re-flip everything else
    telap = CountdownClock(tstart,DIMS.trial_dur,rects);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard(trialrow);
    Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
    Screen('Flip',w);
    
    else %no button ever pressed; updated & reflip everything
    telap = CountdownClock(tstart,DIMS.trial_dur,rects);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard(trialrow);
    Screen('Flip',w);
    end
    
%     FlushEvents();
end

if telap >= DIMS.trial_dur;
    
    DrawFormattedText(w,'Time is up.','center',rects(2,end)+45,COLORS.RED);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard(trialrow);
    [imagerects, imagerects_fail] = DrawImageRects(clicked,1);
    Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
    Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
    Screen('Flip',w);
    outcome = 3;
    time_left = 0;
    
    if ~any(clicked);
        rt_first = NaN;
    end
    WaitSecs(2); % XXX Have subj click on button to continue.
end

score = trial_score;
boxes = length(find(clicked));
clear clickedonbox
end

