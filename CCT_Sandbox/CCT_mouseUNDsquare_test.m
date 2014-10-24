global KEY COLORS w wRect XCENTER YCENTER DIMS STIM CCT trial rects IMAGE

KEY = struct;
KEY.select = KbName('SPACE'); %To end random trial selection
% KEY.one = KbName('1!');
% KEY.two = KbName('2@');
% KEY.tres = KbName('3#');
% KEY.four = KbName('4$');
% KEY.five = KbName('5%');
% KEY.six = KbName('6^');
% KEY.sev = KbName('7&');
% KEY.eight = KbName('8*');
% KEY.nine = KbName('9(');
% KEY.zero = KbName('0)');
% KEY.yes = KbName('y');
% KEY.no = KbName('n');

COLORS = struct;
COLORS.BLACK = [0 0 0];
COLORS.WHITE = [255 255 255];
COLORS.RED = [255 0 0]; 
COLORS.BLUE = [0 0 255];
COLORS.GREEN = [0 255 0];
COLORS.YELLOW = [255 255 0];
COLORS.start = COLORS.BLUE';    %starting color of cards
COLORS.good = COLORS.GREEN';    %color of flipped good card
COLORS.bad = COLORS.RED';       %color of flipped bad card
COLORS.butt = [192 192 192]';   %color of buttons

DIMS = struct;
DIMS.grid_row = 8; %These have to been even numbers...
DIMS.grid_col = 4; %These have to been even numbers...
DIMS.grid_totes = DIMS.grid_row*DIMS.grid_col;

STIM = struct;
STIM.blocks = 3;
STIM.trials = 8;

CCT = struct;
% CCT.var.Block = [[repmat(1,STIM.trials,1); repmat(2,STIM.trials,1)];
% %This might just be different columns of data represnting each block...?
CCT.var.Trial= (1:STIM.trials)';
for g = 1:STIM.blocks;
    CCT.var.trial_dur(1:STIM.trials,g) = repmat(18,STIM.trials,1);              %Sets timer for each trial. If same time every time, remove from loop.
    CCT.var.num_bad(1:STIM.trials,g) = BalanceTrials(STIM.trials,1,[1 3]);      %Loss cards per trial
    CCT.var.scorval(1:STIM.trials,g) = BalanceTrials(STIM.trials,1,[10 30]);   %This is gain amount
    CCT.var.lossval(1:STIM.trials,g) = BalanceTrials(STIM.trials,1,[-250 -750]); %This determines loss amount
end
CCT.data.trialscore = repmat(-999,STIM.trials,STIM.blocks);
CCT.data.cumscore = repmat(-999,STIM.trials,STIM.blocks);             %This is cumulative score (pervert).


% Pics for gain/loss
try
    gain_card = imread('happycard.jpg');
    loss_card = imread('badcard.jpg');
catch
    error('Cannot load images.');
    KbWait();
    sca;
end


commandwindow;


%%
%change this to 0 to fill whole screen
DEBUG=0;

%set up the screen and dimensions

%list all the screens, then just pick the last one in the list (if you have
%only 1 monitor, then it just chooses that one)
Screen('Preference', 'SkipSyncTests', 1)

screenNumber=max(Screen('Screens'));

if DEBUG==1;
    %create a rect for the screen
    winRect=[0 0 640 480];
    %establish the center points
    XCENTER=320;
    YCENTER=240;
else
    %change screen resolution
    %Screen('Resolution',0,1024,768,[],32);
    
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
%you can set the font sizes and styles here
Screen('TextFont', w, 'Arial');
%Screen('TextStyle', w, 1);
Screen('TextSize',w,30);

KbName('UnifyKeyNames');

%% Rects & other constants based off rects
rects = DrawRectsGrid();
DIMS.endtext_loc_y = min(rects(2,:))-20;

%% Set up images; needs to wait for screen setup.

IMAGE = struct;
IMAGE.gain = Screen('MakeTexture',w,gain_card);
IMAGE.loss = Screen('MakeTexture',w,loss_card);

%%
DrawFormattedText(w,'The CCT is ready to begin.\nPress any key to continue.','center','center',COLORS.WHITE);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);

%% Practice?


%% Present multiple trials & blocks.
 for block = 1:STIM.blocks %To institute blocks, uncomment here, below & above in globals
    for trial = 1:STIM.trials;
        %BIOPAC PULSE FOR START
        CCT.data.trialscore(trial,block) = DoCCT();
        CCT.data.cumscore(trial,block) = sum(CCT.data.trialscore(1:trial,block));
        
    end
%     %This is where inter-block questions go.
    if block < STIM.blocks
        endoblock = sprintf('Prepare for Block %d.',block+1);
        DrawFormattedText(w,endoblock,'center','center',COLORS.WHITE);
        Screen('Flip',w);
        KbWait();
    end
 end

%% Randomized payout.



%% End of task.
DrawFormattedText(w,'That concludes this stolen version \n of the Columbia Card Task.','center','center',COLORS.WHITE);
Screen('Flip',w);
WaitSecs(2);

sca

