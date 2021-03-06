function ColumbiaCardTask()
%This Psychtoolbox script was developed by Erik & Smrithi, based on
%Figner's Columbia Card Task. Any questions regarding the task or
% its operation, contact Erik (elk@uoregon.edu) or Smrithi 
% (smrithi@uoregon.edu).
% 
% This task has been tested on Matlab 2011 (& later) and Psychtoolbox 3.
% It has performed admirably on PCs (Windows 7) and OSx 10.7.5.  To
% install, download the CCT_v1.0.0 folder and save to a reasonable
% location. Add the folder location to your Matlab path & save.
% 
% Original files are on Github @ github.com/RickyDMT.


global KEY COLORS w wRect XCENTER YCENTER DIMS STIM CCT rects IMAGE biopac


prompt={'Practice?' 'BioPac (1 = yes)?'};
defAns={'1' '0'};
answer=inputdlg(prompt,'Please input subject info',1,defAns);
prac=str2double(answer{1});
biopac = str2double(answer{2});


commandwindow;
ID = input('Subject ID:');
d = clock;
Mindfulness = input('Condition:');


KbName('UnifyKeyNames');

KEY = struct;
KEY.select = KbName('SPACE'); %To end random trial selection
KEY.ONE= KbName('1!');
KEY.TWO= KbName('2@');
KEY.THREE= KbName('3#');
KEY.FOUR= KbName('4$');
KEY.FIVE= KbName('5%');
KEY.SIX= KbName('6^');
KEY.SEVEN= KbName('7&');
KEY.all = KEY.ONE:KEY.SEVEN;

COLORS = struct;
COLORS.BLACK = [0 0 0];
COLORS.WHITE = [255 255 255];
COLORS.RED = [255 0 0]; 
COLORS.BLUE = [0 0 255];
COLORS.GREEN = [0 255 0];
COLORS.YELLOW = [255 255 0];
COLORS.start = [255; 128; 128];    %starting color of cards
COLORS.good = COLORS.GREEN';    %color of flipped good card
COLORS.bad = COLORS.RED';       %color of flipped bad card
COLORS.butt = [192; 192; 192];   %color of buttons

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
CCT.info = struct('SubjID',ID,'Date',date,'Time',sprintf('%2.0f%02.0f',d(4),d(5)),'Condition',Mindfulness);
CCT.ques = struct('Q1',[],'Q2',[],'Q3',[]);


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
    
% Pics for gain/loss
try
    gain_card = imread('happycard.jpg');
    loss_card = imread('badcard.jpg');
catch
    error('Cannot load images.');
end


%%
%change this to 0 to fill whole screen
DEBUG=1;

%set up the screen and dimensions

%list all the screens, then just pick the last one in the list (if you have
%only 1 monitor, then it just chooses that one)
Screen('Preference', 'SkipSyncTests', 1);

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
Screen('TextStyle', w,1);  %Make it bold.
Screen('TextSize',w,18);

KbName('UnifyKeyNames');

%% Rects & other constants based off rects
rects = DrawRectsGrid();
DIMS.endtext_loc_y = min(rects(2,:))-20;

% Screen('FillRect',w,COLORS.WHITE,rects);
% Screen('Flip',w);

%% BioPac Setup
%This readies the BioPac unit. Uses io64 mex file from
%http://apps.usd.edu/coglab/psyc770/IO64.html with "address" hard coded
%into outp.m file (i.e., 8224 for room 133, 12320 for room 135). For other
%computers, you will need to find your parallel port address and input that hex value as a
%dec into the outp.m file.

%Added 6/22:  For running code on computers without, run "xconfig_io" and
%"xoutp" instead.  Also, if you THINK you have biopac but don't, throw
%error so data isn't lost accidentally.

%Trigger pulses coded in doCompeteTrial.m
if biopac == 1;
    try
        config_io;
    catch
       error('Attempted to initiate the BioPac io64 mex file, but failed. Are you sure the confi_io.m filed is installed and installed properly? Make sure the Mex file from http://apps.usd.edu/coglab/psyc770/IO64.html is installed and functioning properly. Finally, all else fails, contact Erik (elk@uoregon.edu).'); 
    end
    outp(0);
else
    %Do NOTHING!
end


%% Set up images; needs to wait for screen setup.

IMAGE = struct;
IMAGE.gain = Screen('MakeTexture',w,gain_card);
IMAGE.loss = Screen('MakeTexture',w,loss_card);

%% PRACTICE & EXAMPLES?
if prac == 1
%Instructions- Page 1
myFile=fopen('maininstructions.txt','r');
myText=fgetl(myFile);
fclose(myFile);
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(.5);

%Instructions- Page 2
myFile=fopen('maininstructions1.txt','r');
myText=fgetl(myFile);
fclose(myFile);
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(.5);

%Instructions- Page 3
myFile=fopen('maininstructions2.txt','r');
myText=fgetl(myFile);
fclose(myFile);
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,73,[],[],1.5);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(.5);

%Instructions - Page 4
myFile=fopen('maininstructions3.txt','r');
myText=fgetl(myFile);
fclose(myFile);
% [~, ~, textcoord] = DrawFormattedText(w,'TEXT GOES HERE','center','center',COLORS.WHITE,100);  %Use "textcoord" to show where to place image
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,73,[],[],1.5);
%Screen('DrawTexture',w,IMAGE.gain,[],[])    %ADD COORDINATES to SECOND [] BASED OFF OF TEXT POSITION
%Screen('DrawTexture',w,IMAGE.loss,[],[])
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(.5);

%Instructions- Page 5
DrawFormattedText(w,'We will now show you two example trials before we begin.\n\nPress space to begin.','center','center',COLORS.WHITE,70);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(.5);

%Instructions- Page 6
myFile=fopen('Example1.txt','r');
myText=fgetl(myFile);
fclose(myFile);
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,73,[],[],1.5);
%Need image here (of 1 loss card)
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(.5);

%1 loss card, -750 loss, +10 gain
DrawFormattedText(w,'You see 32 unknown cards. The scoreboard shows you that 1 of the cards is a loss card. Each gain card is worth 10 points to you, and the loss card will cost you 750 points. Let us suppose you decide to turn over 7 cards and then stop.','center',wRect(4)-590,COLORS.WHITE,73);
DrawFormattedText(w,'Press any key to reveal cards.','center',wRect(4)-45,COLORS.WHITE);
eGainAmt = 10;
eLossCards = 1;
eLossAmt = -750;
etrial_score = 0;
% clicked = zeros(DIMS.grid_totes,1);
% efail_list = 10; 
rectcolor = repmat(COLORS.start,1,(DIMS.grid_totes));
rectcolor = [rectcolor COLORS.butt];
Screen('FillRect',w,rectcolor,rects);                       %Draws rectangles.
DoScoreboard(0,eLossCards,eLossAmt,eGainAmt,etrial_score);
Screen('Flip',w);
KbWait();
%And then reveal
clicked = zeros(DIMS.grid_totes,1);
eclicked = randperm(DIMS.grid_totes,7);

for ex_step = 1:7;
    etrial_score = etrial_score + eGainAmt;
    clicked(eclicked(1:ex_step)) = 1;
    
    Screen('FillRect',w,rectcolor,rects);    
    DoScoreboard(0,eLossCards,eLossAmt,eGainAmt,etrial_score);
    [imagerects] = DrawImageRects(clicked);
    Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
    % Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
%     CountdownClock(tstart,DIMS.trial_dur,rects);    %Runs & displays countdown clock
    Screen('Flip',w);
    WaitSecs(.5);
end

WaitSecs(2);
Screen('FillRect',w,rectcolor,rects);
DoScoreboard(0,eLossCards,eLossAmt,eGainAmt,etrial_score);
[imagerects] = DrawImageRects(clicked);
Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
DrawFormattedText(w,'Luckily, none of the seven cards you turned over happened to be the loss card, so your score for this round was 70. Press space to see the next example.','center',wRect(4)-580,COLORS.WHITE,73);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);


% Instructions- Page 5
% myFile=fopen('Example1reveal.txt','r');
% myText=fgetl(myFile);
% fclose(myFile);
% DrawFormattedText(w,myText,'center','center',COLORS.WHITE,100);
% %Need image here (of 3 loss card)
% Screen('Flip',w);
% KbWait;
% Screen('Flip',w);
% WaitSecs(2);

%Instructions- Page 7
myFile=fopen('Example2.txt','r');
myText=fgetl(myFile);
fclose(myFile);
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,73,[],[],1.5);
Screen('Flip',w);
KbWait();
WaitSecs(2);

DrawFormattedText(w,'The scoreboard shows you that 3 of these cards are loss cards. Turning over each gain card is worth 30 points to you, and turning over a loss card will cost you 250 points. Let us suppose you decide to turn over 10 cards.','center',wRect(4)-590,COLORS.WHITE,73);
DrawFormattedText(w,'Press any key to reveal cards.','center',wRect(4)-45,COLORS.WHITE);
eGainAmt = 30;
eLossCards = 3;
eLossAmt = -250;
etrial_score = 0;
efail_list = [2;10;11];

Screen('FillRect',w,rectcolor,rects);                       %Draws rectangles.
DoScoreboard(0,eLossCards,eLossAmt,eGainAmt,etrial_score);
Screen('Flip',w);

KbWait();
WaitSecs(2);
%And then reveal
clicked = zeros(DIMS.grid_totes,1);
eclicked = [5;23;14;2];

for ex_step = 1:4;
    
    clicked(eclicked(1:ex_step)) = 1;
    
    [imagerects] = DrawImageRects(clicked);
    Screen('FillRect',w,rectcolor,rects);

    if ex_step == 4;
        %reveal loss card
        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
        Screen('DrawTextures',w,IMAGE.loss,[],imagerects(:,1)); %Note, this is a misuse of "imagerects." In DoCCT, imagerects_fail is used instead.
            etrial_score = etrial_score + eLossAmt;
    else
        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
        etrial_score = etrial_score + eGainAmt;
    end
    DoScoreboard(0,eLossCards,eLossAmt,eGainAmt,etrial_score);    
    % Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
%     CountdownClock(tstart,DIMS.trial_dur,rects);    %Runs & displays countdown clock
    Screen('Flip',w);
    WaitSecs(.5);
end


WaitSecs(2);
Screen('FillRect',w,rectcolor,rects);
DoScoreboard(0,eLossCards,eLossAmt,eGainAmt,etrial_score,1);
[imagerects, imagerects_fail] = DrawImageRects(clicked,efail_list);
Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
DrawFormattedText(w,'This time, the fourth card you turned was a loss card.  The round immediately will end when you turn over a loss card.  Press space to learn more about this trial.','center',wRect(4)-580,COLORS.WHITE,73);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);


%Instructions- Page 8
myFile=fopen('Example2reveal.txt','r');
myText=fgetl(myFile);
fclose(myFile);
DrawFormattedText(w,myText,'center','center',COLORS.WHITE,73,[],[],1.5);
%Need image here
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);


%% Practice

DrawFormattedText(w,'You will now complete two practice rounds of the game. \n\nPlease use the mouse to select the cards that you want to turn over. \n\nPress space to begin.','center','center',COLORS.WHITE,70,[],[],1.5);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);


for prac_trial = 1:2;
   [~,~,~,~,~] = DoCCT(0);
end
Screen('Flip',w);

%Instructions- Page 9
DrawFormattedText(w,'Before the game starts, we would like to ask you a few questions about the task.\n\n Please wait for further instructions from the experimenter','center','center',COLORS.WHITE,70,[],[],1.5);
%Need image here
Screen('Flip',w);
% KbName();
while 1
    [dddown,~,cccode] = KbCheck();
%     endcode = find(ccode);
    if dddown && find(cccode) == KbName('F12');
%         if endcode(2) == KbName('LeftShift') && endcode(1) == KbName('q')
            break
%         end
    end
end

Screen('Flip',w);
WaitSecs(2);

end

%% Present multiple trials & blocks.
DrawFormattedText(w,'You are now all set to begin. \n\nPlease press space to continue.','center','center',COLORS.WHITE,70,[],[],1.5);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);

if Mindfulness == 1 || Mindfulness == 4;
    myFile=fopen('CONDITION1.txt','r');
elseif Mindfulness == 2 || Mindfulness == 3;
        myFile=fopen('CONDITION2.txt','r');
end

    myText=fgetl(myFile);
    fclose(myFile);
    DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
    Screen('Flip',w);
    WaitSecs(30);

    
DrawFormattedText(w,'Prepare for Block 1.','center','center',COLORS.WHITE,60,[],[],1.5);
Screen('Flip',w);
WaitSecs(2);

 for block = 1:STIM.blocks %To institute blocks, uncomment here, below & above in globals
    for trial = 1:STIM.trials;
        %BIOPAC PULSE FOR START
        if biopac == 1;
            outp(1);
            WaitSecs(.01);
            outp(0);
        end

        trialrow = (block-1)*STIM.trials + trial;
        
        [CCT.data(trialrow).trialscore, CCT.data(trialrow).Outcome, CCT.data(trialrow).boxes, CCT.data(trialrow).time_left, CCT.data(trialrow).rt_firstclick] = DoCCT(trialrow);
        
    end
    
%End of Block  
if block <= STIM.blocks
        endoblock = sprintf('You have come to the end of Block %d. \n\nNow we want you to answer some questions before you proceed to the next Block.\n\nPress space to continue.',block);
        DrawFormattedText(w,endoblock,'center','center',COLORS.WHITE,60,[],[],1.5);
        Screen('Flip',w);
        KbWait();
 end

    
%     %This is where inter-block questions go.
    %Question Text here.
    ib_qs = {'How PLEASANT are you feeling RIGHT NOW?\n\n\nIndicate your response on the scale below by pressing the corresponding number of the keyboard.\n\n\n\n\n\n\nSCALE: 1=Not at all and 7=Extremely';
        'How physiologically (bodily) AROUSED are you feeling RIGHT NOW?\n\n\nIndicate your response on the scale below by pressing the corresponding number of the keyboard.\n\n\n\n\n\n\nSCALE: 1=Not at all and 7=Extremely';
        'How DOMINANT are you feeling RIGHT NOW?\n\n\nIndicate your response on the scale below by pressing the corresponding number of the keyboard.\n\n\n\n\n\n\nSCALE: 1=Not at all and 7=Extremely'
        'How CONFIDENT are you feeling RIGHT NOW?\n\n\nIndicate your response on the scale below by pressing the corresponding number of the keyboard.\n\n\n\n\n\n\nSCALE: 1=Not at all and 7=Extremely'};
    
    for ibq = 1:4;
        
        DrawFormattedText(w,ib_qs{ibq},'center','center',COLORS.WHITE,60,[],[],1.5);
        drawRatings();
        Screen('Flip',w);
        
        while 1
            [rate_press, ~, rate_key] = KbCheck();
            if rate_press && any(rate_key(KEY.all))
                DrawFormattedText(w,ib_qs{ibq},'center','center',COLORS.WHITE,60,[],[],1.5);
                rating = KbName(find(rate_key,1));
                rating = str2num(rating(1)); %#ok<*ST2NM>
                drawRatings(rate_key);
                Screen('Flip',w);
                WaitSecs(.25);
                
                if ibq == 1;
                    CCT.ques(block).Q1 = rating;
                elseif ibq == 2;
                    CCT.ques(block).Q2 = rating;
                elseif ibq == 3;
                    CCT.ques(block).Q3 = rating;
                elseif ibq == 4;
                    CCT.ques(block).Q4 = rating;
                end
                Screen('Flip',w);
                WaitSecs(.25);
                break
            end
        end
        
    end
    
    Screen('Flip',w);
    WaitSecs(.5);
    
    if block < STIM.blocks
        endoblock = sprintf('Prepare for Block %d.',block+1);
    elseif block == STIM.blocks
        endoblock = 'Now we will choose random trials to calculate the bonus points!';
    end
        DrawFormattedText(w,endoblock,'center','center',COLORS.WHITE);
        Screen('Flip',w);
        WaitSecs(4);
 end

%% Randomized payout.
%Where should random numbers be displayed? What size?
numsq_side = 90;
numsq_y1 = repmat(fix(wRect(4)/3),1,3);
numsq_y2 = numsq_y1 + numsq_side;
numsq_texty = numsq_y1 + numsq_side/2;
numsq_textx = [fix(wRect(3)/4) fix(wRect(3)/2) fix(wRect(3)*(3/4))];
numsq_x1 = numsq_textx - (numsq_side/2);
numsq_x2 = numsq_x1 + numsq_side;

squares4nums = [numsq_x1; numsq_y1; numsq_x2; numsq_y2];
trials_selected = NaN(3,1);

%TURN THIS TO ONE & DONE.

for rnd_trial = 1:3;
    FlushEvents();
    while 1
        selected = randperm(STIM.trials,3);
%         if rnd_trial == 1;
            s1 = sprintf('%d',selected(1));
            s2 = sprintf('%d',selected(2));
            s3 = sprintf('%d',selected(3));
        
        Screen('FillRect',w,COLORS.WHITE,squares4nums);
        Screen('TextSize',w,60);
        CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.RED);
        CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.RED);
        CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.RED);
        Screen('TextSize',w,30);
        DrawFormattedText(w,'Press the space bar to choose\nthe bonus trials from each block!','center',wRect(4)/8,COLORS.WHITE);

        Screen('Flip',w);

        [Down, ~, Code] = KbCheck();
            if Down == 1 && any(find(Code) == KEY.select);
                trials_selected = selected;
                WaitSecs(.01);

                break;
            end
    end
end

% Display trials selected.
Screen('FillRect',w,COLORS.WHITE,squares4nums);
oldtextsize = Screen('TextSize',w,60);
CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.RED);
CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.RED);
CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.RED);
Screen('TextSize',w,oldtextsize);
DrawFormattedText(w,'You have selected the following trials.\nPlease wait while your points are determined.','center',wRect(4)/8,COLORS.WHITE);
Screen('Flip',w);
WaitSecs(5);


% Display points earned.
pay_trial(1) = CCT.data(trials_selected(1)).trialscore;
pay_trial(2) = CCT.data(STIM.trials+trials_selected(2)).trialscore;
pay_trial(3) = CCT.data(STIM.trials*2 + trials_selected(3)).trialscore;


CenterTextOnPoint(w,num2str(pay_trial(1)),numsq_textx(1),numsq_texty(1),COLORS.WHITE);
CenterTextOnPoint(w,num2str(pay_trial(2)),numsq_textx(2),numsq_texty(2),COLORS.WHITE);
CenterTextOnPoint(w,num2str(pay_trial(3)),numsq_textx(3),numsq_texty(3),COLORS.WHITE);
Screen('TextSize',w,oldtextsize);
DrawFormattedText(w,'You have earned the following points,\nbased on the random trials selected.','center',wRect(4)/8,COLORS.WHITE,68,[],[],1.5);
% DrawFormattedText(w,['Bonus points: ' sprintf('%d',total_pay) '\n\n\nThis concludes the task.\nPlease alert the experimenter.'],'center',numsq_y2(1)+50,COLORS.WHITE,60, [],[],1.5);
DrawFormattedText(w,'This concludes the task.\nPlease alert the experimenter.','center',numsq_y2(1)+50,COLORS.WHITE,60, [],[],1.5);
Screen('Flip',w);
% KbWait();

% NOTE: This saves the trial number that was chosen for each block in one
% column and the points in another column. Erik will be confused later.
CCT.payment = [trials_selected; pay_trial]';


%Experimenter presses the F12 key  to end the task & save the file, once they
%have written down the total payment.

while 1
    [ddown,~,ccode] = KbCheck();
%     endcode = find(ccode);
    if ddown && find(ccode) == KbName('F12');
%         if endcode(2) == KbName('LeftShift') && endcode(1) == KbName('q')
            break
%         end
    end
end
Screen('Flip',w);

%% SAVE
%Save structure here
[mdir,~,~] = fileparts(which('CCT.m'));
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


sca

end

%% These are the guts of task: Runs all the actual trial generation & display.

function [ score, outcome, boxes, time_left,rt_first ] = DoCCT(trialrow)
%CCT Runs Columbia card task, trial-by-trial
%   Coded by: ELK

global w DIMS CCT COLORS rects IMAGE STIM biopac



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


DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);

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
            DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
            Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
            Screen('Flip',w);
            
        else %no button ever pressed; updated & reflip everything
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
            Screen('Flip',w);
        end

    end
    
    while ~any(buttons) && telap < DIMS.trial_dur % wait for press
        [~,~,buttons] = GetMouse();
        if any(clicked)
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
            Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
            Screen('Flip',w);
            
        else %no button ever pressed; updated & reflip everything
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
            Screen('Flip',w);
        end
    end
    
    while any(buttons) && telap < DIMS.trial_dur % wait for release
        button = 1;
        [x,y,buttons] = GetMouse();
        if any(clicked)
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
            Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
            Screen('Flip',w);
            
        else %no button ever pressed; updated & reflip everything
            telap = CountdownClock(tstart,DIMS.trial_dur,rects);
            Screen('FillRect',w,rectcolor,rects);
            DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
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
                        if biopac == 1;
                            outp(4);
                            WaitSecs(.01);
                            outp(0);
                        end
                        
                        trial_score = trial_score + LossAmt;
                        
%                         DrawFormattedText(w,'You lose.','center',rects(2,end)+45,COLORS.RED);
                        %Screen('FillRect',w,rectcolor,rects);
                        DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
                        [imagerects, imagerects_fail] = DrawImageRects(clicked,fail_list);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                        Screen('Flip',w);
                        outcome = 0;
                        time_left = DIMS.trial_dur - (clicktime);
                        if length(find(clicked)) == 1;
                            rt_first = clicktime;
                        end
                        WaitSecs(.5); 
                        
                        break
                    elseif length(clicked(clicked==1)) == (DIMS.grid_totes - LossCards); %You clicked very last gain card
                        %BIOPAC PULSE
                        if biopac == 1;
                            outp(4);
                            WaitSecs(.01);
                            outp(0);
                        end
                        
                        Screen('Flip',w);

                        trial_score = trial_score + GainAmt;
                        DrawFormattedText(w,'You win.','center',rects(2,end)+45,COLORS.RED);


                        [imagerects, imagerects_fail] = DrawImageRects(clicked,fail_list);
%                         Screen('DrawTextures',w,IMAGE.gain);
%                         Screen('DrawTextures',w,IMAGE.loss);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                        DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
                        
                        Screen('Flip',w);
                        
                        WaitSecs(.5);
                        
                        outcome = 1;
                        time_left = DIMS.trial_dur - (clicktime);                        
                        break
                        
                    else %You clicked a gain card
                        %BioPacPulse
                        if biopac == 1;
                            outp(2);
                            WaitSecs(.01);
                            outp(0);
                        end
                        
                        trial_score = trial_score + GainAmt;
                        Screen('FillRect',w,rectcolor,rects);
                        [imagerects] = DrawImageRects(clicked);
                        Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                        telap = CountdownClock(tstart,DIMS.trial_dur,rects);
                        DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
                        Screen('Flip',w);
                        
                        if length(find(clicked)) == 1;
                            rt_first = clicktime;
                        end
                        
                    end
                end
            elseif clickedonbox == DIMS.grid_totes+1 %End trial button
                %Biopac pulse
                if biopac == 1;
                    outp(4);
                    WaitSecs(.01);
                    outp(0);
                end
                
                
                Screen('FillRect',w,rectcolor,rects);
                if ~any(clicked);
                    rt_first = NaN;
                end
                DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
                [imagerects, imagerects_fail] = DrawImageRects(clicked,fail_list);
                Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
                Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
                Screen('Flip',w);
                outcome = 2;
                time_left = DIMS.trial_dur - (clicktime);
                WaitSecs(.5); 
                
                break
            end
        end
    end
      
end

if telap >= DIMS.trial_dur;
    if biopac == 1;
        outp(4);
        WaitSecs(.01);
        outp(0);
    end
    
    DrawFormattedText(w,'Time is up.','center',rects(2,end)+45,COLORS.RED);
    Screen('FillRect',w,rectcolor,rects);
    DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score);
    [imagerects, imagerects_fail] = DrawImageRects(clicked,fail_list);
    Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
    Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
    Screen('Flip',w);
    outcome = 3;
    time_left = 0;
    
    if ~any(clicked);
        rt_first = NaN;
    end
    WaitSecs(.5); % XXX Have subj click on button to continue.
end

DrawFormattedText(w,'Press "Next Trial" to continue.','center',rects(2,end)+45,COLORS.GREEN);
Screen('FillRect',w,rectcolor,rects);
DoScoreboard(trialrow,LossCards,LossAmt,GainAmt,trial_score,1);
[imagerects, imagerects_fail] = DrawImageRects(clicked,fail_list);
Screen('DrawTextures',w,IMAGE.gain,[],imagerects);
Screen('DrawTextures',w,IMAGE.loss,[],imagerects_fail);
Screen('Flip',w);

while 1
[xxx, yyy, bbb] = GetMouse();
    if any(bbb)
        xxmin = rects(1,end)<=xxx;
        xxmax = rects(3,end)>=xxx;
        yymin = rects(2,end)<=yyy;
        yymax = rects(4,end)>=yyy;
        clicked_next_trial = find(xxmin & xxmax & yymin & yymax);
        if ~isempty(clicked_next_trial);
            break
        end

    end
end

FlushEvents();

score = trial_score;
boxes = length(find(clicked));
clear clickedonbox
end

%% This the timer for the task:  Calculates time left in given trial, displays clock.
function [ telap ] = CountdownClock( tstart,ttotes,rects,varargin )
%CountdownClock Puts a fucking clock on the screen.
%   Detailed explanation goes up yer ass.

global w COLORS

telap = round(toc(tstart)*10)/10;

if telap >= ttotes
    telap = ttotes;
    tleft = 0;
else
    tleft = ttotes - telap;
end

tdisp = sprintf('%02.1f',tleft);

if tleft >8
    DrawFormattedText(w,tdisp,'center',rects(2,end)+45,COLORS.GREEN);
else
    DrawFormattedText(w,tdisp,'center',rects(2,end)+45,COLORS.RED);
end


end

%% Displays trial score info.

function [  ] = DoScoreboard(trialrow, losscards, lossamt, gainamt, tscore, varargin )
%DoDisplayScores Displays stuff on screen.

global w rects CCT COLORS wRect

%Base all locations off of some variable to allow proper scaling to
%different screens.
% Screen('FillRect',w,COLORS.WHITE,rects);

oldsize = Screen('TextSize',w,20);
% tscore = trial_score;

lossa_loc_x = fix(wRect(3)*.05);
gaina_loc_x = fix(wRect(3)/2);                %Use CenterTextonPoint: This value represents middle coordinate of text box
lossc_loc_x = fix((wRect(3)*(9/10))-200);      %Write text that ends at 10% border on right side of screen, ASSUMES 100 pixel length

botrow_y = rects(2,end) - 30;
toprow_y = botrow_y - 28;
% left_loc_x = 10;
% bads_loc_y = 40;
% loss_loc_y = bads_loc_y +20;

%Right side of score board -- Uses 'right' & wRect to right justify
% scorval_loc_y = 40;
% tscore_loc_y = scorval_loc_y + 20;


%Button text locations
% nocard_x = rects(1,length(rects)-1) + 50;
% nocard_y = rects(2,length(rects)-1) + 12;
stop_x = rects(1,length(rects))+50;
stop_y = rects(2,length(rects))+12;

lossc_text = sprintf('Num. of Loss Cards: %d',losscards);%CCT.var(trialrow).LossCards);
lossa_text = sprintf('Loss Amount: %d',lossamt);%CCT.var(trialrow).LossAmt);
gaina_text = sprintf('Gain Amount: %d',gainamt);%CCT.var(trialrow).GainAmt);


tscore_text = sprintf('Trial Score: %d',tscore);
if trialrow == 0;
    trial_text = 'Trial: Example';
else
    trial_text = sprintf('Trial: %d',CCT.var(trialrow).Trial);
end

% if trial == 1; 
%     cumscore_text = 'Total Score: 0        ';
% else
%     cumscore_text = sprintf('Total Score: %d        ',CCT.data.cumscore(trial-1));
% end

%Bottomw Row of scoreboard
DrawFormattedText(w,lossc_text,lossc_loc_x,botrow_y,COLORS.WHITE);
DrawFormattedText(w,lossa_text,lossa_loc_x,botrow_y,COLORS.WHITE);
CenterTextOnPoint(w,gaina_text,gaina_loc_x,botrow_y+10,COLORS.WHITE);

%Top Row of scoreboard
DrawFormattedText(w,tscore_text,lossc_loc_x,toprow_y,COLORS.WHITE);
DrawFormattedText(w,trial_text,lossa_loc_x,toprow_y,COLORS.WHITE);


%Button text

if nargin == 6;
    DrawFormattedText(w,'Next Trial','center',rects(2,end)+2,COLORS.BLACK);
else
    DrawFormattedText(w,'STOP!','center',rects(2,end)+2,COLORS.BLACK);
end


Screen('TextSize',w,oldsize);

% Screen('Flip',w);

end

%% Draws pass/fail/unflipped cards.

function [ varargout ] = DrawImageRects( clicked, varargin )
%Gives location for gain/loss images on cards.
%If calling function for apocolyptic "end of trial" big reveal, then call
%with "1" as a second input in addition to "clicked" (the cards that have
%been clicked

global rects

%bring in "clicked" array of cards that have been clicked.

if nargin == 1;
    if any(clicked)
        imagerects = rects(:,clicked==1);
        varargout{1} = imagerects;
    end
elseif nargin == 2;
    fail_list = varargin{1};
    
    imagerects_fail = rects(:,fail_list);
    imagerects = rects(:,1:length(clicked));
    imagerects(:,fail_list) = [];
%     for n_out = 1:nargout;
        varargout{1} = imagerects;
        varargout{2} = imagerects_fail;
    
end



end

%% Draws inter-block ratings on screen

function drawRatings(varargin)

global w wRect XCENTER COLORS KEY;

num_rects = 7;

xlen = wRect(3)*.9;           %Make area covering about 90% of vertical dimension of screen.
gap = 10;                       %Gap size between each rect
square_side = fix((xlen - (num_rects-1)*gap)/num_rects); %Size of rect depends on size of screen.

squart_x = XCENTER-(xlen/2);
squart_y = wRect(4)*.8;         %Rects start @~80% down screen.

rate_rects = zeros(4,num_rects);

% for row = 1:DIMS.grid_row;
    for col = 1:num_rects;
%         currr = ((row-1)*DIMS.grid_col)+col;
        rate_rects(1,col)= squart_x + (col-1)*(square_side+gap);
        rate_rects(2,col)= squart_y;
        rate_rects(3,col)= squart_x + (col-1)*(square_side+gap)+square_side;
        rate_rects(4,col)= squart_y + square_side;
    end
% end
mids = [rate_rects(1,:)+square_side/2; rate_rects(2,:)+square_side/2+5];

rate_colors=repmat(COLORS.WHITE',1,num_rects);
% rects=horzcat(allRects.rate1rect',allRects.rate2rect',allRects.rate3rect',allRects.rate4rect');

%Needs to feed in "code" from KbCheck, to show which key was chosen.
if nargin >= 1 && ~isempty(varargin{1})
    response=varargin{1};
    
    key=find(response);
    if length(key)>1
        key=key(1);
    end;
    
    switch key
        
        case {KEY.ONE}
            choice=1;
        case {KEY.TWO}
            choice=2;
        case {KEY.THREE}
            choice=3;
        case {KEY.FOUR}
            choice=4;
        case {KEY.FIVE}
            choice=5;
        case {KEY.SIX}
            choice=6;
        case {KEY.SEVEN}
            choice=7;
%         case {KEYS.EIGHT}
%             choice=8;
%         case {KEYS.NINE}
%             choice=9;
%          case {KEYS.TEN}
%             choice = 10;
    end
    
    if exist('choice','var')
        
        
        rate_colors(:,choice)=COLORS.GREEN';
        
    end
end


    window=w;
   

% Screen('TextFont', window, 'Arial');
% Screen('TextStyle', window, 1);
oldSize = Screen('TextSize',window,35);

% Screen('TextFont', w2, 'Arial');
% Screen('TextStyle', w2, 1)
% Screen('TextSize',w2,60);



%draw all the squares
Screen('FrameRect',window,rate_colors,rate_rects,1);


% Screen('FrameRect',w2,colors,rects,1);


%draw the text (1-10)
for n = 1:num_rects;   
    numnum = sprintf('%d',n);
    CenterTextOnPoint(window,numnum,mids(1,n),mids(2,n),COLORS.WHITE);
end


Screen('TextSize',window,oldSize);

end

%% Creates coordinates for rects throughout task.
function [ rects ] = DrawRectsGrid(varargin)
%DrawRectGrid:  Builds a grid of rectangles with a gap in between.
%   Future added functionality:  Have it pick colors based on mouse
%   selection.

global DIMS wRect

xcenter = fix(wRect(3)/2);
ycenter = fix(wRect(4)*(5/8));


gap = 20;
square_side = ((wRect(4)*(.55) - (gap*(DIMS.grid_row-1)))/DIMS.grid_row);  %Base square size on available verticle height of screen
%DIMS.grid_row = 4;
%DIMS.grid_col = 2;
squart_x = xcenter-((square_side*DIMS.grid_col)+(gap*(DIMS.grid_col-1)))/2;
squart_y = ycenter-((square_side*DIMS.grid_row)+(gap*(DIMS.grid_row-1)))/2;

rects = zeros(4,(DIMS.grid_totes));

for row = 1:DIMS.grid_row;
    for col = 1:DIMS.grid_col;
        currr = ((row-1)*DIMS.grid_col)+col;
        rects(1,currr)= squart_x + (col-1)*(square_side+gap);
        rects(2,currr)= squart_y + (row-1)*(square_side+gap);
        rects(3,currr)= squart_x + (col-1)*(square_side+gap)+square_side;
        rects(4,currr)= squart_y + (row-1)*(square_side+gap)+square_side;
    end
end

% % No clicks, please
%     rects(1,length(rects)+1)= xcenter - ((2*square_side)+1.5*gap);
%     rects(2,length(rects))= squart_y - ((square_side/2)+2*gap);
%     rects(3,length(rects))= xcenter - gap/2;
%     rects(4,length(rects))= squart_y - 2*gap;
    
% Just end it all!
    rects(1,length(rects)+1)= xcenter- (square_side + .5*gap);
    rects(2,length(rects))= squart_y - ((square_side)+2*gap);
    rects(3,length(rects))= xcenter + (square_side + .5*gap);
    rects(4,length(rects))= squart_y - fix((square_side/2)+2*gap);

end



%% This Centers text on certain coordinates on the screen.
function [nx, ny, textbounds] = CenterTextOnPoint(win, tstring, sx, sy,color)
% [nx, ny, textbounds] = DrawFormattedText(win, tstring [, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft])
%
% 

numlines=1;

if nargin < 1 || isempty(win)
    error('CenterTextOnPoint: Windowhandle missing!');
end

if nargin < 2 || isempty(tstring)
    % Empty text string -> Nothing to do.
    return;
end

% Store data class of input string for later use in re-cast ops:
stringclass = class(tstring);

% Default x start position is left border of window:
if isempty(sx)
    sx=0;
end

% if ischar(sx) && strcmpi(sx, 'center')
%     xcenter=1;
%     sx=0;
% else
%     xcenter=0;
% end

xcenter=0;

% No text wrapping by default:
% if nargin < 6 || isempty(wrapat)
    wrapat = 0;
% end

% No horizontal mirroring by default:
% if nargin < 7 || isempty(flipHorizontal)
    flipHorizontal = 0;
% end

% No vertical mirroring by default:
% if nargin < 8 || isempty(flipVertical)
    flipVertical = 0;
% end

% No vertical mirroring by default:
% if nargin < 9 || isempty(vSpacing)
    vSpacing = 1;
% end

% if nargin < 10 || isempty(righttoleft)
    righttoleft = 0;
% end

% Convert all conventional linefeeds into C-style newlines:
newlinepos = strfind(char(tstring), '\n');

% If '\n' is already encoded as a char(10) as in Octave, then
% there's no need for replacemet.
if char(10) == '\n' %#ok<STCMP>
   newlinepos = [];
end

% Need different encoding for repchar that matches class of input tstring:
if isa(tstring, 'double')
    repchar = 10;
elseif isa(tstring, 'uint8')
    repchar = uint8(10);    
else
    repchar = char(10);
end

while ~isempty(newlinepos)
    % Replace first occurence of '\n' by ASCII or double code 10 aka 'repchar':
    tstring = [ tstring(1:min(newlinepos)-1) repchar tstring(min(newlinepos)+2:end)];
    % Search next occurence of linefeed (if any) in new expanded string:
    newlinepos = strfind(char(tstring), '\n');
end

% % Text wrapping requested?
% if wrapat > 0
%     % Call WrapString to create a broken up version of the input string
%     % that is wrapped around column 'wrapat'
%     tstring = WrapString(tstring, wrapat);
% end

% Query textsize for implementation of linefeeds:
theight = Screen('TextSize', win) * vSpacing;

% Default y start position is top of window:
if isempty(sy)
    sy=0;
end

winRect = Screen('Rect', win);
winHeight = RectHeight(winRect);

% if ischar(sy) && strcmpi(sy, 'center')
    % Compute vertical centering:
    
    % Compute height of text box:
%     numlines = length(strfind(char(tstring), char(10))) + 1;
    bbox = SetRect(0,0,1,numlines * theight);
    bbox = SetRect(0,0,1,theight);
    
    
    textRect=CenterRectOnPoint(bbox,sx,sy);
    % Center box in window:
    [rect,dh,dv] = CenterRect(bbox, textRect);

    % Initialize vertical start position sy with vertical offset of
    % centered text box:
    sy = dv;
% end

% Keep current text color if noone provided:
if nargin < 5 || isempty(color)
    color = [];
end

% Init cursor position:
xp = sx;
yp = sy;

minx = inf;
miny = inf;
maxx = 0;
maxy = 0;

% Is the OpenGL userspace context for this 'windowPtr' active, as required?
[previouswin, IsOpenGLRendering] = Screen('GetOpenGLDrawMode');

% OpenGL rendering for this window active?
if IsOpenGLRendering
    % Yes. We need to disable OpenGL mode for that other window and
    % switch to our window:
    Screen('EndOpenGL', win);
end

% Disable culling/clipping if bounding box is requested as 3rd return
% % argument, or if forcefully disabled. Unless clipping is forcefully
% % enabled.
% disableClip = (ptb_drawformattedtext_disableClipping ~= -1) && ...
%               ((ptb_drawformattedtext_disableClipping > 0) || (nargout >= 3));
% 

disableClip=1;

% Parse string, break it into substrings at line-feeds:
while ~isempty(tstring)
    % Find next substring to process:
    crpositions = strfind(char(tstring), char(10));
    if ~isempty(crpositions)
        curstring = tstring(1:min(crpositions)-1);
        tstring = tstring(min(crpositions)+1:end);
        dolinefeed = 1;
    else
        curstring = tstring;
        tstring =[];
        dolinefeed = 0;
    end

    if IsOSX
        % On OS/X, we enforce a line-break if the unwrapped/unbroken text
        % would exceed 250 characters. The ATSU text renderer of OS/X can't
        % handle more than 250 characters.
        if size(curstring, 2) > 250
            tstring = [curstring(251:end) tstring]; %#ok<AGROW>
            curstring = curstring(1:250);
            dolinefeed = 1;
        end
    end
    
    if IsWin
        % On Windows, a single ampersand & is translated into a control
        % character to enable underlined text. To avoid this and actually
        % draw & symbols in text as & symbols in text, we need to store
        % them as two && symbols. -> Replace all single & by &&.
        if isa(curstring, 'char')
            % Only works with char-acters, not doubles, so we can't do this
            % when string is represented as double-encoded Unicode:
            curstring = strrep(curstring, '&', '&&');
        end
    end
    
    % tstring contains the remainder of the input string to process in next
    % iteration, curstring is the string we need to draw now.

    % Perform crude clipping against upper and lower window borders for
    % this text snippet. If it is clearly outside the window and would get
    % clipped away by the renderer anyway, we can safe ourselves the
    % trouble of processing it:
    if disableClip || ((yp + theight >= 0) && (yp - theight <= winHeight))
        % Inside crude clipping area. Need to draw.
        noclip = 1;
    else
        % Skip this text line draw call, as it would be clipped away
        % anyway.
        noclip = 0;
        dolinefeed = 1;
    end
    
    % Any string to draw?
    if ~isempty(curstring) && noclip
        % Cast curstring back to the class of the original input string, to
        % make sure special unicode encoding (e.g., double()'s) does not
        % get lost for actual drawing:
        curstring = cast(curstring, stringclass);
        
        % Need bounding box?
%         if xcenter || flipHorizontal || flipVertical
            % Compute text bounding box for this substring:
            bbox=Screen('TextBounds', win, curstring, [], [], [], righttoleft);
%         end
        
        % Horizontally centered output required?
%         if xcenter
            % Yes. Compute dh, dv position offsets to center it in the center of window.
%             [rect,dh] = CenterRect(bbox, winRect);
            [rect,dh] = CenterRect(bbox, textRect);
            % Set drawing cursor to horizontal x offset:
            xp = dh;
%         end
            
%         if flipHorizontal || flipVertical
%             textbox = OffsetRect(bbox, xp, yp);
%             [xc, yc] = RectCenter(textbox);
% 
%             % Make a backup copy of the current transformation matrix for later
%             % use/restoration of default state:
%             Screen('glPushMatrix', win);
% 
%             % Translate origin into the geometric center of text:
%             Screen('glTranslate', win, xc, yc, 0);
% 
%             % Apple a scaling transform which flips the direction of x-Axis,
%             % thereby mirroring the drawn text horizontally:
%             if flipVertical
%                 Screen('glScale', win, 1, -1, 1);
%             end
%             
%             if flipHorizontal
%                 Screen('glScale', win, -1, 1, 1);
%             end
% 
%             % We need to undo the translations...
%             Screen('glTranslate', win, -xc, -yc, 0);
%             [nx ny] = Screen('DrawText', win, curstring, xp, yp, color, [], [], righttoleft);
%             Screen('glPopMatrix', win);
%         else
            [nx ny] = Screen('DrawText', win, curstring, xp, yp, color, [], [], righttoleft);
%         end
    else
        % This is an empty substring (pure linefeed). Just update cursor
        % position:
        nx = xp;
        ny = yp;
    end

    % Update bounding box:
    minx = min([minx , xp, nx]);
    maxx = max([maxx , xp, nx]);
    miny = min([miny , yp, ny]);
    maxy = max([maxy , yp, ny]);

    % Linefeed to do?
    if dolinefeed
        % Update text drawing cursor to perform carriage return:
        if xcenter==0
            xp = sx;
        end
        yp = ny + theight;
    else
        % Keep drawing cursor where it is supposed to be:
        xp = nx;
        yp = ny;
    end
    % Done with substring, parse next substring.
end

% Add one line height:
maxy = maxy + theight;

% Create final bounding box:
textbounds = SetRect(minx, miny, maxx, maxy);

% Create new cursor position. The cursor is positioned to allow
% to continue to print text directly after the drawn text.
% Basically behaves like printf or fprintf formatting.
nx = xp;
ny = yp;

% Our work is done. If a different window than our target window was
% active, we'll switch back to that window and its state:
if previouswin > 0
    if previouswin ~= win
        % Different window was active before our invocation:

        % Was that window in 3D mode, i.e., OpenGL rendering for that window was active?
        if IsOpenGLRendering
            % Yes. We need to switch that window back into 3D OpenGL mode:
            Screen('BeginOpenGL', previouswin);
        else
            % No. We just perform a dummy call that will switch back to that
            % window:
            Screen('GetWindowInfo', previouswin);
        end
    else
        % Our window was active beforehand.
        if IsOpenGLRendering
            % Was in 3D mode. We need to switch back to 3D:
            Screen('BeginOpenGL', previouswin);
        end
    end
end

return;
end

