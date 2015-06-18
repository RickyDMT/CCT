function CCT_go()

global KEY COLORS w wRect XCENTER YCENTER DIMS STIM CCT rects IMAGE
%Add "Press space to start round."
%Fix spacing in task.

prompt={'Practice?'};
defAns={'1'};
answer=inputdlg(prompt,'Please input subject info',1,defAns);
prac=str2double(answer{1});

commandwindow;
ID = input('Subject ID:');
d = clock;
Mindfulness = input('Condition:');

% cond = input('Condition:');
% fail1='Program aborted. Participant number not entered';% error messagewhich is printed to command window
%  prompt = {'Enter participant number:'};
%  dlg_title ='New Participant';
%  num_lines = 1;
%  def = {'0'};
%  answer = inputdlg(prompt,dlg_title,num_lines,def);%presents box to enterdata into
%  switch isempty(answer)
%      case 1%deals with both cancel and X presses
%      error(fail1)
%      case 0
%          thissub=(answer{1});
%  end
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
% KEY.EIGHT= KbName('8*');
% KEY.NINE= KbName('9(');
KEY.all = KEY.ONE:KEY.SEVEN;

%Hey there!
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
%computers, find the parallel port address and input that hex value as a
%dec into the outp.m file.

%Trigger pulses coded in doCompeteTrial.m
config_io;
outp(0);

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

if Mindfulness == 1
    myFile=fopen('CONDITION1.txt','r');
    myText=fgetl(myFile);
    fclose(myFile);
    DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
    Screen('Flip',w);
    WaitSecs(30);
else
    if Mindfulness == 2
        myFile=fopen('CONDITION2.txt','r');
        myText=fgetl(myFile);
        fclose(myFile);
        DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
        Screen('Flip',w);
        WaitSecs(30);
    else
        if Mindfulness == 3
            myFile=fopen('CONDITION2.txt','r');
            myText=fgetl(myFile);
            fclose(myFile);
            DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
            Screen('Flip',w);
            WaitSecs(30);
        else 
            if Mindfulness == 4
            myFile=fopen('CONDITION1.txt','r');
            myText=fgetl(myFile);
            fclose(myFile);
            DrawFormattedText(w,myText,'center','center',COLORS.WHITE,70,[],[],1.5);
            Screen('Flip',w);
            WaitSecs(30);  
            end
        end
    end
end

DrawFormattedText(w,'Prepare for Block 1.','center','center',COLORS.WHITE,60,[],[],1.5);
Screen('Flip',w);
% KbWait;
% Screen('Flip',w);
WaitSecs(2);

 for block = 1:STIM.blocks %To institute blocks, uncomment here, below & above in globals
    for trial = 1:STIM.trials;
        %BIOPAC PULSE FOR START
        outp(1);
        WaitSecs(.01);
        outp(0);

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
        endoblock = 'Now we will choose random trials to pay the bonus money!';
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
%         elseif rnd_trial == 2;
%             s1 = sprintf('%d',trials_selected(1));
%             s2 = sprintf('%d',selected(2));
%             s3 = sprintf('%d',selected(3));
%         elseif rnd_trial == 3;
%             s1 = sprintf('%d',trials_selected(1));
%             s2 = sprintf('%d',trials_selected(2));
%             s3 = sprintf('%d',selected(3));
%         end
        
        Screen('FillRect',w,COLORS.WHITE,squares4nums);
        Screen('TextSize',w,60);
        CenterTextOnPoint(w,s1,numsq_textx(1),numsq_texty(1),COLORS.RED);
        CenterTextOnPoint(w,s2,numsq_textx(2),numsq_texty(2),COLORS.RED);
        CenterTextOnPoint(w,s3,numsq_textx(3),numsq_texty(3),COLORS.RED);
        Screen('TextSize',w,30);
        DrawFormattedText(w,'Press the space bar to choose\na trials from each block to payout!','center',wRect(4)/8,COLORS.WHITE);

        Screen('Flip',w);

        [Down, ~, Code] = KbCheck();
            if Down == 1 && any(find(Code) == KEY.select);
                trials_selected = selected;
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
DrawFormattedText(w,'You have earned the following amount,\nbased on the random trials selected.','center',wRect(4)/8,COLORS.WHITE,68,[],[],1.5);
DrawFormattedText(w,['Bonus payment: $' sprintf('%0.2f',total_pay) '\n\n\nThis concludes the task.\nPlease alert the experimenter.'],'center',numsq_y2(1)+50,COLORS.WHITE,60, [],[],1.5);
Screen('Flip',w);
% KbWait();
CCT.payment = pay_trial';


%Experimenter presses 'q' and the left shift key simultaneously to end the task & save the file, once they
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
