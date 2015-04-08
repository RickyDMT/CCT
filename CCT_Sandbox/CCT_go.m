function CCT_go()

global KEY COLORS w wRect XCENTER YCENTER DIMS STIM CCT rects IMAGE
%Add "Press space to start round."
%Fix spacing in task.
commandwindow;
ID = input('Subject ID:');
d = clock;

KEY = struct;
KEY.select = KbName('SPACE'); %To end random trial selection 

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
CCT.info = struct('SubjID',ID,'Date',date,'Time',sprintf('%2.0f%02.0f',d(4),d(5)));

% CCT.var.Block = [[repmat(1,STIM.trials,1); repmat(2,STIM.trials,1)];
% %This might just be different columns of data represnting each block...?

% CCT.var.Trial= (1:STIM.trials)';

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
end


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

% Screen('FillRect',w,COLORS.WHITE,rects);
% Screen('Flip',w);

%% Set up images; needs to wait for screen setup.

IMAGE = struct;
IMAGE.gain = Screen('MakeTexture',w,gain_card);
IMAGE.loss = Screen('MakeTexture',w,loss_card);

%%
%Instructions


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
    %Question Text here.
%     [press, ~, keycode] = KbCheck();
    

    if block < STIM.blocks
        endoblock = sprintf('Prepare for Block %d.',block+1);
        DrawFormattedText(w,endoblock,'center','center',COLORS.WHITE);
        Screen('Flip',w);
        KbWait();
    end
 end

%% Randomized payout.
%Where should random numbers be displayed? What size?
numsq_side = 75;
numsq_y1 = repmat(fix(wRect(4)/3),1,3);
numsq_y2 = numsq_y1 + numsq_side;
numsq_texty = numsq_y1 + numsq_side/2;
numsq_textx = [fix(wRect(3)/4) fix(wRect(3)/2) fix(wRect(3)*(3/4))];
numsq_x1 = numsq_textx - (numsq_side/2);
numsq_x2 = numsq_x1 + numsq_side;

squares4nums = [numsq_x1; numsq_y1; numsq_x2; numsq_y2];
trials_selected = NaN(3,1);

for rnd_trial = 1:3;
    FlushEvents();
    while 1
        selected = randperm(STIM.trials,3);
        if rnd_trial == 1;
            s1 = sprintf('%d',selected(1));
            s2 = sprintf('%d',selected(2));
            s3 = sprintf('%d',selected(3));
        elseif rnd_trial == 2;
            s1 = sprintf('%d',trials_selected(1));
            s2 = sprintf('%d',selected(2));
            s3 = sprintf('%d',selected(3));
        elseif rnd_trial == 3;
            s1 = sprintf('%d',trials_selected(1));
            s2 = sprintf('%d',trials_selected(2));
            s3 = sprintf('%d',selected(3));
        end
        
        Screen('FillRect',w,COLORS.WHITE,squares4nums);
        Screen('TextSize',w,60);
        CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.RED);
        CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.RED);
        CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.RED);
        Screen('TextSize',w,30);
        DrawFormattedText(w,'Press the space bar to choose\na trial from each block to payout!','center',wRect(4)/8,COLORS.WHITE);

        Screen('Flip',w);

        [Down, ~, Code] = KbCheck();
            if Down == 1 && any(find(Code) == KEY.select);
                trials_selected(rnd_trial) = selected(rnd_trial);
                WaitSecs(.01);

                break;
            end
    end
end

Screen('FillRect',w,COLORS.WHITE,squares4nums);
oldtextsize = Screen('TextSize',w,60);
CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.RED);
CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.RED);
CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.RED);
Screen('TextSize',w,oldtextsize);
DrawFormattedText(w,'You have selected the following trials.\nPlease wait while the payout is calculated.','center',wRect(4)/8,COLORS.WHITE);
Screen('Flip',w);
WaitSecs(5);

pay_trial(1) = CCT.data(trials_selected(1)).trialscore/100;
pay_trial(2) = CCT.data(STIM.trials+trials_selected(2)).trialscore/100;
pay_trial(3) = CCT.data(STIM.trials*2 + trials_selected(3)).trialscore/100;

if any(pay_trial < 0)
    pay_trial(pay_trial<0) = 0;
end

total_pay = sum(pay_trial);

CenterTextOnPoint(w,['$' num2str(pay_trial(1))],numsq_textx(1),numsq_texty(1),COLORS.WHITE);
CenterTextOnPoint(w,['$' num2str(pay_trial(2))],numsq_textx(2),numsq_texty(2),COLORS.WHITE);
CenterTextOnPoint(w,['$' num2str(pay_trial(3))],numsq_textx(3),numsq_texty(3),COLORS.WHITE);
Screen('TextSize',w,oldtextsize);
DrawFormattedText(w,'You have earned the following amount,\nbased on the random trials selected.','center',wRect(4)/8,COLORS.WHITE);
DrawFormattedText(w,['Bonus payment: $' sprintf('%0.2f',total_pay) '\n\n\nThis concludes the task.\nPlease alert the experimenter.'],'center',numsq_y2(1)+50,COLORS.WHITE);
Screen('Flip',w);
% KbWait();
CCT.payment = pay_trial';


%Experimenter presses 'q' and the left shift key simultaneously to end the task & save the file, once they
%have written down the total payment.

while 1
    [ddown,~,ccode] = KbCheck();
    endcode = find(ccode);
    if ddown && length(endcode) == 2;
        if endcode(2) == KbName('LeftShift') && endcode(1) == KbName('q')
            break
        end
    end
end

%Save structure here
[mdir,~,~] = fileparts(which('CCT_go.m'));
savedir = [mdir filesep 'Results'];
savename = sprintf('CCT_%03.0f.mat',ID);
% cd(savedir);

if exist([savedir filesep savename],'file')==2;
    savename = sprintf('CCT_%03.0f_%s_%2.0f%02.0f.mat',ID,date,d(4),d(5));
end

try
    save([savedir filesep savename],'CCT');
catch
    try
        warning('Something is amiss with this save. Retrying save in: %s\n',mdir);
        save([mdir filesep savename],'CCT');
    catch
        warning('STILL problems saving. Will attempt to save entire worksapce in whatever folder computer is currently in: %s\n',pwd);
        save CCT
    end
end


%% End of task.
% DrawFormattedText(w,'That concludes this stolen version \n of the Columbia Card Task.','center','center',COLORS.WHITE);
% Screen('Flip',w);
% WaitSecs(2);

sca

end
