global COLORS KEY
% %%
% % From Jason's testing script. Will be removed.
% 
% %change this to 0 to fill whole screen
% DEBUG=0;
% 
% %set up the screen and dimensions
% 
% %list all the screens, then just pick the last one in the list (if you have
% %only 1 monitor, then it just chooses that one)
% %screenNumber=max(Screen('Screens'));
% %screenNumber=1;
% 
% if DEBUG;
%     %create a rect for the screen
%     winRect=[0 0 640 480];
%     %establish the center points
%     XCENTER=320;
%     YCENTER=240;
% else
%     %change screen resolution
%     Screen('Resolution',0,1024,768,[],32);
%     
%     %this gives the x and y dimensions of our screen, in pixels.
%     [swidth1, sheight1] = Screen('WindowSize', 1);
%     XCENTER1=fix(swidth1/2);
%     YCENTER1=fix(sheight1/2);
%     [swidth2, sheight2] = Screen('WindowSize', 2);
%     XCENTER2=fix(swidth2/2);
%     YCENTER2=fix(sheight2/2);
%     %when you leave winRect blank, it just fills the whole screen
%     winRect=[];
% end

%open a window on that monitor. 32 refers to 32 bit color depth (millions of
%colors), winRect will either be a 1024x768 box, or the whole screen. The
%function returns a window "w", and a rect that represents the whole
%screen.
[swidth, sheight] = Screen('WindowSize', 1); %This should be determined prior to this and assigned a variable?
XCENTER=fix(swidth/2);
YCENTER=fix(sheight/2);
Screen('Resolution',0,1024,768,[],32);

Screen('Preference', 'SkipSyncTests', 1);
winRect = [];
[w1, wRect]=Screen('OpenWindow', 1, 0,winRect,32,2);
[w2, wRect]=Screen('OpenWindow', 2, 0,winRect,32,2);


%you can set the font sizes and styles here
Screen('TextFont', w1, 'Arial');
Screen('TextStyle', w1, 1);
Screen('TextSize',w1,40);
Screen('TextFont', w2, 'Arial');
Screen('TextStyle', w2, 1);
Screen('TextSize',w2,40);

%%
COLORS=struct;
COLORS.RED=[255 0 0 255];
COLORS.BLUE=[0 0 255 255]; 

screenss = 2;
%%

 
        DrawFormattedText(w1,'This is screen numero 1','center',YCENTER,COLORS.RED);
        Screen('Flip',w1);
        
if screenss==2;
        DrawFormattedText(w2,'This is screen dos','center',YCENTER,COLORS.BLUE);
        Screen('Flip',w2);
end

WaitSecs(2);

DrawFormattedText(w1,'This is screen uno y dos','center','center',COLORS.BLUE);
DrawFormattedText(w2,'This is screen uno y dos','center','center',COLORS.BLUE);
Screen('Flip',w1,[],[],[],1);
WaitSecs(2);
sca;

