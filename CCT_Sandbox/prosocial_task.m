%%Prosocial Decision Making Task (proDMT)
clear all

global w trial eye eye_text destRect YCENTER XCENTER KEY COLORS TIMING STIM proDMT allRects

%%

%dialog box for subject ID and session type
prompt={'SUBJECT ID'};

%default values
defAns={'4444'};

answer = inputdlg(prompt,'Please input subject and session info',1,defAns);

SUBID=str2double(answer{1});

rng(SUBID,'twister');


%%

%change this to 0 to fill whole screen
DEBUG=1;

%set up the screen and dimensions

%list all the screens, then just pick the last one in the list (if you have
%only 1 monitor, then it just chooses that one)
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
%you can set the font sizes and styles here
Screen('TextFont', w, 'Arial');
Screen('TextStyle', w, 1);
Screen('TextSize',w,20);
Screen('Preference', 'SkipSyncTests', 1);

%%
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
%KEY.enter = KbName('Return');
KEY.yes = KbName('y');
KEY.no = KbName('n');

COLORS=struct;
COLORS.WHITE=[255 255 255 255];
COLORS.BLACK=[0 0 0 255];
COLORS.GRAY=[140 140 140 255];
COLORS.GREEN=[0 255 0 255];
COLORS.RED=[255 0 0 255];
COLORS.BLUE=[0 0 255 255]; 
COLORS.ORANGE=[238 139 0 255];
COLORS.PURPLE=[129 12 220 255];

TIMING=struct;
TIMING.intro=2;
TIMING.quest=1;
TIMING.feed=.5;
TIMING.end=2;

%This is for the various parameters with regards to stimulus presentations
STIM=struct;
STIM.trials = 4;               %number of trials to run
STIM.kb = -1;                   %determines which keyboard to use
STIM.leftmarg = XCENTER-200;    %Left margin for presenting text. Should be updated to respond to screen size.

%Make stuctures here for i/o data
proDMT = struct;
proDMT.Var.Trial= (1:STIM.trials)'; %makes verticle list of trial number, 1 through STIM.trials
[proDMT.Var.Money_Endowed, proDMT.Var.Mult_Char, proDMT.Var.Observe] = BalanceTrials(STIM.trials,1,[2 4 6],[.75 1 1.25 1.75],[1 2]);
% proDMT.Var.Money_Endowed = BalanceTrials(STIM.trials,1,[3 6 9]); %input endowment variables here
% proDMT.Var.Mult_Char = BalanceTrials(STIM.trials,1,[.75 1 1.25 1.75]); %input multiplier variables here
% proDMT.Var.Observe = BalanceTrials(STIM.trials,1,[1 2]); %determines randomized obeserved or not (1 = open/public, 2 = closed/private)
proDMT.Data.SUBID = repmat(SUBID,STIM.trials,1);
proDMT.Data.Amt_Donated = repmat(-999,STIM.trials,1);
proDMT.Data.Amt_You = repmat(-999,STIM.trials,1);
proDMT.Data.Amt_Char = repmat(-999,STIM.trials,1);
proDMT.Data.donate_RT = repmat(-999,STIM.trials,1);
proDMT.Data.confirm_RT = [];
proDMT.Data.satRate = repmat(-999,STIM.trials,1);
proDMT.Data.sat_RT = repmat(-999,STIM.trials,1);

%Attempted fix of drawRatings from 5/1/14
ratings_spacing=150;
ratings_width=70;
ratings_height=40;

allRects.rate1_coords=[XCENTER-fix(1.5*ratings_spacing),YCENTER+125];
allRects.rate2_coords=[XCENTER-fix(.5*ratings_spacing),YCENTER+125];
allRects.rate3_coords=[XCENTER+fix(.5*ratings_spacing),YCENTER+125];
allRects.rate4_coords=[XCENTER+fix(1.5*ratings_spacing),YCENTER+125];

raterect=[0 0 ratings_width ratings_height];
allRects.rate1rect=CenterRectOnPoint(raterect,allRects.rate1_coords(1),allRects.rate1_coords(2));
allRects.rate2rect=CenterRectOnPoint(raterect,allRects.rate2_coords(1),allRects.rate2_coords(2));
allRects.rate3rect=CenterRectOnPoint(raterect,allRects.rate3_coords(1),allRects.rate3_coords(2));
allRects.rate4rect=CenterRectOnPoint(raterect,allRects.rate4_coords(1),allRects.rate4_coords(2));

%%
%Prosocial Decision Making Task (Pro-DMT)

commandwindow;
ListenChar(2);
HideCursor;
KbName('UnifyKeyNames');

%for BioPac Triggering
% config_io;          %fire up parallel port 
% address = 8224;     %change per computer
% outp(address,0);    %set to 0 to start.
% for startup = 1:3;
%     outp(address,1);
%     WaitSecs(.03);
%     outp(address,0);
%     WaitSecs(.03);
% end

%Pre-load image for observed v. unobserved
open_eye = imread('open_eye.png');
closed_eye = imread('closed_eye.png');
openTexture = Screen('MakeTexture',w,open_eye);
closedTexture = Screen('MakeTexture',w,closed_eye);
eyeTexture = [openTexture closedTexture];
[imgH, imgW, ~] = size(open_eye);
eye_pp = {'Public' 'Private'};

%Define image rect as  some percent (1/scalefactor) of total screen size
%May not be necessary, but allows eye to be scaled with screen size.
%Figure out WTF is wrong with the horizontal dimension.
scalefactor = 4;
%this is what was wrong imgRect = wRect/scalefactor;
imgRect = [0 0 imgW/scalefactor imgH/scalefactor];

%set margin border for distance of img from edge of screen
border = 10; 

%Place scaled image in center of rect that is defined by screen size,
%scaled imaged, & border.
scaleRect = [XCENTER-(imgW/2) border XCENTER+(imgW/2) border+imgH];
destRect = CenterRect(imgRect,scaleRect);

%Disable all keys accept numerals & Y/N response keys.
%keysofinterest = zeros(1,256); %Moved to within trial in order to reset
keylist = [KEY.yes KEY.no KEY.zero KEY.one KEY.two KEY.tres KEY.four KEY.five KEY.six KEY.sev KEY.eight KEY.nine];

%"How much would you like to donate" - Removed from initial location in
%loop.
quest_text = sprintf('How much would you like to donate?');

%%
%Present Instructions

KbReleaseWait;
    
DrawFormattedText(w,'The decision making task is about to begin.\nPress any key to continue.','center','center',COLORS.WHITE);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(TIMING.intro);

%%

%Present trials

for trial=1:STIM.trials;
    %for collecting multiple attempts at each trial (i.e., confirm = no)
    %k=0;
    
    %Use proDMT.Var.Observe to determine eyes or not
    eye = eyeTexture(proDMT.Var.Observe(trial));
    eye_text = eye_pp{proDMT.Var.Observe(trial)};
    
    %Biopac Trigger;
%     b_trial=[1 0 0 0];
%     if proDMT.Var.Observe(trial)==1;
%         b_trial(2) = 2;
%     end
%     b_sum = sum(b_trial);
    
    %Present deal with theDealio function.
    
    theDealio();
    drawRatings();
%     outp(address,1);
%     WaitSecs(.05);
%     outp(address,b_sum); %BioPac Trigger
    sat_startSecs=Screen('Flip',w,[],1);

    while 1
        [keyisdown, rateResponseSecs, keycode] = KbCheck();

        if (keyisdown==1 && (keycode(KEY.one) || keycode(KEY.two) || keycode(KEY.tres) || keycode(KEY.four)))

%             outp(address,b_sum);
            drawRatings(keycode);
            Screen('Flip',w);
            WaitSecs(.25);
            %yrateResp= rateResponseSecs-r;
            %rt=rateResponseSecs-startsecs;
            sat_pressedKey = KbName(find(keycode));
            proDMT.Data.satRate(trial) = str2double(sat_pressedKey(1)); %record satisfaction rating
            proDMT.Data.sat_RT(trial) = rateResponseSecs-sat_startSecs; %record straight to proDMT;
            break;
        end
    end
    
    %Decide what keys are acceptable.
    %keysofinterest = zeros(1,256);
    %keylist_trial = keylist(1:proDMT.Var.Money_Endowed(trial)+3);
    %keysofinterest(keylist_trial)=1;
    %KbQueueCreate(STIM.kb,keysofinterest);    
    %RestrictKeysForKbCheck(keylist_trial);
    
    theDealio();
    %quest_text = sprintf('How much would you like to donate?');
    %DrawFormattedText(w,quest_text,'center',YCENTER+25,COLORS.RED);
    startSecs = Screen('Flip',w,[],1);
%     outp(address,1);
%     WaitSecs(.05);
%     outp(address,b);
    
    %KbQueueStart(STIM.kb);
    confirm = 0;
    while confirm == 0;
        
        %confirm2=0;
  
        %Subject Input
        %[press, key]=KbQueueCheck();
        %[press, sec, key]=KbCheck();
        
        %if press;
        key = GetEchoNumber(w,quest_text,XCENTER-300,YCENTER+25,COLORS.RED,COLORS.BLACK);
            DMT_RT = GetSecs - startSecs;
            
            if isempty(key) || key > proDMT.Var.Money_Endowed(trial) || key < 0;
            %if find(key) == KEY.yes || find(key) == KEY.no;
                %KbQueueFlush();
                FlushEvents();
                DrawFormattedText(w,'Invalid Response.','center',YCENTER+100,COLORS.RED);
                Screen('Flip',w);
                WaitSecs(1.5);
                theDealio();
                startSecs = Screen('Flip',w,[],1);
            else
                donation = round(key);
                confirm = 1;
%                 outp(address,1);
%                 WaitSecs(.05);
%                 outp(address,b);
                %pressedKey = KbName(find(key));
                %pressedNum = str2double(pressedKey(1));
                %DMT_RT = sec-startSecs; %record straight to proDMT at (i,j);
                %KbQueueStop(STIM.kb);
                %KbQueueFlush(STIM.kb);
                %FlushEvents();

                %Check screen
%                 checkscreen = sprintf('You have selected to donate $%.2f.\n\nIs this correct? \n\n Y or N',pressedNum);
%                 DrawFormattedText(w,checkscreen,'center',YCENTER+50,COLORS.RED);
%                 [confirm_onset] = Screen('Flip',w);            
                
                %KbQueueStart(STIM.kb);
%                 while confirm2==0;
%                     %[confirm_press, confirm_firstpress] = KbQueueCheck(STIM.kb);
%                     [confirm_press, confirmsec, confirm_firstpress] = KbCheck();
%                     if confirm_press && confirm_firstpress(KEY.yes);
%                         confirm = 1;
%                         confirm2 = 1;
%                         %k = k+1;
%                         %record RT for each attempt? proDMT.Data.confirm_RT(i,k) = confirm_firstpress(find(confirm_firstpress)) - confirm_onset;
%                     elseif confirm_press && confirm_firstpress(KEY.no);
%                         %k = k+1;
%                         %record RT for each attempt? proDMT.Data.confirm_RT(i,k) = confirm_firstpress(find(confirm_firstpress)) - confirm_onset;
% %                         KbQueueStop(STIM.kb);
% %                         KbQueueFlush(STIM.kb);
% %                         KbQueueStart(STIM.kb);
%                         FlushEvents();
%                         confirm2 = 1;
%                         theDealio();
%                         DrawFormattedText(w,quest_text,'center',YCENTER+25,COLORS.RED);
%                         Screen('Flip',w,[],1);
%                         outp(address,1);
%                         WaitSecs(.05);
%                         outp(address,b);
%                     end
%                 end
            end
        %end
    end
    
    %Once participant chooses amount and confirms choice, exit both while
    %loops and record data to proDMT.
    
    %RT
    proDMT.Data.donate_RT(trial) = DMT_RT;
    %Amount donated
    proDMT.Data.Amt_Donated(trial)=donation;
    
    
    %Calculate & record round $ and total in pot
    proDMT.Data.Amt_You(trial) = proDMT.Var.Money_Endowed(trial) - donation;
    proDMT.Data.Amt_Char(trial) = donation * proDMT.Var.Mult_Char(trial);
        
    Screen('Flip',w);
    WaitSecs(TIMING.feed);

    %Display amounts for round & in total.
    amt_you_gave_text = sprintf('You have chosen to give $%.2f to FfLC.',donation);
    amt_you_recv_text = sprintf('You received $%.2f.',proDMT.Data.Amt_You(trial));
    amt_char_text = sprintf('FfLC received $%.2f.',proDMT.Data.Amt_Char(trial));
    %amt_you_totes_text = sprintf('You now have %.2f dollars.',you_totes);
    %amt_char_totes_text = sprintf('FfLC now has %.2f dollars.',char_totes);
    DrawFormattedText(w,amt_you_gave_text,'center',YCENTER-100,COLORS.WHITE);
    DrawFormattedText(w,amt_you_recv_text,'center',YCENTER+50,COLORS.GREEN);
    DrawFormattedText(w,amt_char_text,'center',YCENTER-50,COLORS.GREEN);
    DrawFormattedText(w,eye_text,'center',YCENTER-150,COLORS.WHITE);
    %DrawFormattedText(w,'Press any key to continue.','center',YCENTER+100,COLORS.WHITE);
    Screen('DrawTexture',w,eye,[],destRect);
    Screen('Flip',w,[],1);
%     outp(address,1);
    WaitSecs(.05);
%     outp(address,b);
    
    WaitSecs(TIMING.end);
    DrawFormattedText(w,'Press any key to continue.','center',YCENTER+100,COLORS.WHITE);
    Screen('Flip',w,[],1);
    
    FlushEvents();
%     RestrictKeysForKbCheck([]);
    
%     %Biopac Trigger
%     outp(address,0);
    
    %Press any key;
    KbWait(-1);
    Screen('Flip',w);
    WaitSecs(1);
end

ListenChar;
ShowCursor;

%Export pro.DMT to text and save with subject number.

%find the mfilesdir by figuring out where show_faces.m is kept
[mfilesdir,name,ext] = fileparts(which('prosocial_task.m'));

%get the parent directory, which is one level up from mfilesdir
[parentdir,~,~] =fileparts(mfilesdir);


%create the paths to the other directories, starting from the parent
%directory
savedir = [parentdir filesep 'Results/'];

save([savedir 'proDMT_' num2str(SUBID)]);
Screen('CloseAll');
