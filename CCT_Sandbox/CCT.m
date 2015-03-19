function CCT()

global KEY COLORS w wRect XCENTER YCENTER DIMS STIM CCT rects IMAGE
%Add "Press space to start round."
%Fix spacing in task.

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
%Hey there!
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
DIMS.grid_row = 4; %These have to been even numbers...
DIMS.grid_col = 8; %These have to been even numbers...
DIMS.grid_totes = DIMS.grid_row*DIMS.grid_col;
DIMS.trial_dur = 18;

STIM = struct;
STIM.blocks = 3;
STIM.trials = 8;
STIM.lossc = [1 3];
STIM.lossamt = [-250 -750];
STIM.gainamt = [10 30];

CCT.var = struct('Block',[],'Trial',[],'LossCards',[],'LossAmt',[],'GainAmt',[]);
CCT.data = struct('Block',[],'Trial',[],'Outcome',[],'trialscore',[],'rt_firstclick',[],'boxes',[],'time_left',[]);
% CCT.var.Block = [[repmat(1,STIM.trials,1); repmat(2,STIM.trials,1)];
% %This might just be different columns of data represnting each block...?

% CCT.var.Trial= (1:STIM.trials)';

%Prac trials
    
for g = 1:STIM.blocks;
    [lossc, lossamt, gainamt] = BalanceTrials(STIM.trials,1,STIM.lossc,STIM.lossamt,STIM.gainamt);
    
    %Add data structure creation for interblock questionnaires here.
    
    for h = 1:STIM.trials;
        varow = (g-1)*STIM.trials + h;
        CCT.var(varow).Block = g;
        CCT.var(varow).Trial = h;
        CCT.var(varow).LossCards = lossc(h);
        CCT.var(varow).LossAmt = lossamt(h);
        CCT.var(varow).GainAmt = gainamt(h);
        
        CCT.data(varow).Block = g;
        CCT.data(varow).Trial = h;
        CCT.data(varow).Outcome = NaN;
        CCT.data(varow).trialscore = NaN;
        CCT.data(varow).rt_firstclick = NaN;
        CCT.data(varow).boxes = NaN;
        CCT.data(varow).time_left = NaN;
    end
end
    
%     CCT.var.trial_dur(1:STIM.trials,g) = repmat(18,STIM.trials,1);              %Sets timer for each trial. If same time every time, remove from loop.
%     CCT.var.num_bad(1:STIM.trials,g) = BalanceTrials(STIM.trials,1,[1 3]);      %Loss cards per trial
%     CCT.var.scorval(1:STIM.trials,g) = BalanceTrials(STIM.trials,1,[10 30]);   %This is gain amount
%     CCT.var.lossval(1:STIM.trials,g) = BalanceTrials(STIM.trials,1,[-250 -750]); %This determines loss amount
    

% CCT.data.trialscore = repmat(-999,STIM.trials,STIM.blocks);
% CCT.data.cumscore = repmat(-999,STIM.trials,STIM.blocks);             %This is cumulative score (pervert).


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
DEBUG=1;

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

% Screen('FillRect',w,COLORS.WHITE,rects);
% Screen('Flip',w);

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
%         outp(1);
%         WaitSecs(.05);

        trialrow = (block-1)*STIM.trials + trial;
        
        [CCT.data(trialrow).trialscore, CCT.data(trialrow).Outcome, CCT.data(trialrow).boxes, CCT.data(trialrow).time_left, CCT.data(trialrow).rt_firstclick] = DoCCT(trialrow);
        
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

end
