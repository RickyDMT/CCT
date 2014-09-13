global KEY COLORS w winRect XCENTER YCENTER DIMS STIM CCT trial

KEY = struct;
KEY.one = KbName('1!');
KEY.two = KbName('2@');
KEY.tres = KbName('3#');
KEY.four = KbName('4$');
KEY.five = KbName('5%');
KEY.six = KbName('6^');
KEY.sev = KbName('7&');
KEY.eight = KbName('8*');
KEY.nine = KbName('9(');
KEY.zero = KbName('0)');
KEY.yes = KbName('y');
KEY.no = KbName('n');

COLORS = struct;
COLORS.BLACK = [0 0 0];
COLORS.WHITE = [255 255 255];
COLORS.RED = [255 0 0];
COLORS.BLUE = [0 0 255];
COLORS.GREEN = [0 255 0];
COLORS.YELLOW = [255 255 0];

DIMS = struct;
DIMS.grid_row = 4;
DIMS.grid_col = 2;
DIMS.grid_totes = DIMS.grid_row*DIMS.grid_col;

STIM = struct;
%STIM.blocks = 2;
STIM.trials = 8;

CCT = struct;
%CCT.var.Block = [[repmat(1,STIM.trials,1); repmat(2,STIM.trials,1)]
CCT.var.Trial= (1:STIM.trials)';
CCT.var.num_bad = BalanceTrials(STIM.trials,1,[1 3]);
CCT.data.score = repmat(-999,STIM.trials,1);

%KbQueueCreate();
%KbQueueStart(-1);

commandwindow;


%%
%change this to 0 to fill whole screen
DEBUG=1;

%set up the screen and dimensions

%list all the screens, then just pick the last one in the list (if you have
%only 1 monitor, then it just chooses that one)
Screen('Preference', 'SkipSyncTests', 1)

screenNumber=max(Screen('Screens'));

if DEBUG;
    %create a rect for the screen
    winRect=[0 0 640 480];
    %establish the center points
    XCENTER=320;
    YCENTER=240;
else
    %change screen resolution
    Screen('Resolution',0,1024,768,[],32);
    
    %this gives the x and y dimensions of our screen, in pixels.
    [swidth, sheight] = Screen('WindowSize', screenNumber);
    XCENTER=fix(swidth/2);
    YCENTER=fix(sheight/2);
    %when you leave winRect blank, it just fills the whole screen
    winRect=[];
end

%open a window on that monitor. 32 refers to 32 bit color depth (millions of
%colors), winRect will either be a 1024x768 box, or the whole screen. The
%function returns a window "w", and a rect that represents the whole
%screen. 
[w, wRect]=Screen('OpenWindow', screenNumber, 0,winRect,32,2);

%%
DrawFormattedText(w,'The CCT is ready to begin.\nPress any key to continue.','center','center',COLORS.WHITE);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);

%Present multiple trials.
% for block = 1:STIM.blocks %To institute blocks, uncomment here, below & above in globals
    for trial = 1:STIM.trials;
        CCT.data.score(trial) = DoCCT();
    end
%     %This is where inter-block questions go.
%     DrawFormattedText(w,'Prepare yourself for Block 2','center','center',COLORS.WHITE);
%     Screen('Flip',w);
% end

%WaitSecs(2);

DrawFormattedText(w,'Mouse test. Go!','center','center',COLORS.GREEN);
Screen('Flip',w);

telap = 0;
tstart = tic;
% texttt = 'Press a button, I dare you.';
while telap < 10;
    telap = CountdownClock(tstart,10);
    Screen('Flip',w);
    [x,y,buttons] = GetMouse();
    if buttons(1)
        texttt = sprintf('You clicked at %d & %d.',x,y);
        DrawFormattedText(w,texttt,'center',YCENTER-50,COLORS.BLUE);
        telap = CountdownClock(tstart,10);
        Screen('Flip',w);
    else
        DrawFormattedText(w,texttt,'center',YCENTER-50,COLORS.BLUE);
        telap = CountdownClock(tstart,10);
        Screen('Flip',w,0,1);
    end
end
fprintf('%f',toc(tstart))

DrawFormattedText(w,'Trrrrrhat is .','center',100,COLORS.GREEN);
Screen('Flip',w,0,1);
DrawFormattedText(w,'sssssassaa.','center','center',COLORS.GREEN);
Screen('Flip',w);
WaitSecs(2);
sca
%%
%you can set the font sizes and styles here
% Screen('TextFont', w, 'Arial');
% Screen('TextStyle', w, 1);
% Screen('TextSize',w,20);
% 
%% Predetermine certain things like location of squares, etc.
%playarea = winRECT(4)*(1/3); %Play area = lower 2/3 of screen.
    
    
