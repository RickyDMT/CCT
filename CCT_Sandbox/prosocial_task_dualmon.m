%%Prosocial Decision Making Task (proDMT)

function prosocial_task_dualmon(ID)

global w  w2 trial eye eye_text destRect YCENTER XCENTER KEY COLORS TIMING STIM proDMT allRects

w = NaN;
w2 = NaN;

mydir = fileparts(which(mfilename)); %get the directory where this files lives
cd(mydir); %...and move there
%because you named drawRatings the same! :-)

%%

%This IF statement is crashing the script.
if exist('ID', 'var') == 0

%dialog box for subject ID and session type
prompt={'SUBJECT ID'};

%default values
defAns={'4444'};

answer = inputdlg(prompt,'Please input subject and session info',1,defAns);

ID=str2double(answer{1});

end

rng(ID,'twister');

%%

Screen('Preference','SkipSyncTests',1);

%change this to 0 to fill whole screen
DEBUG=0;
%set up the screen and dimensions

if DEBUG;
    %create a rect for the screen
    winRect=[0 0 640 480];
    %establish the center points
    XCENTER=320;
    YCENTER=240;
    [w, wRect]=Screen('OpenWindow', 1, 0,winRect,32,2)
else

    screennumber = 1; %min(Screen('Screens')); %gets screen number
    screennumber2 = 2; %max(Screen('Screens'));
    %change screen resolution
    %Screen('Resolution',0,1600,900,[],32);
    

    [w, wrect] = Screen('OpenWindow', screennumber,0);
    %[xdim, ydim] = Screen('WindowSize', screennumber);

    
    Screen('TextFont', w, 'Arial');
    Screen('TextStyle', w, 1);
    Screen('TextSize',w,36);
    
    if screennumber~=screennumber2
        
        [w2, wrect2] = Screen('OpenWindow', screennumber2,0);
        Screen('TextFont', w2, 'Arial');
        Screen('TextStyle', w2, 1);
        Screen('TextSize',w2,36);
        
    end
    
    if screennumber==screennumber2
        
        w2=w;
        
    end
    
    %this gives the x and y dimensions of our screen, in pixels.
    [swidth, sheight] = Screen('WindowSize', screennumber);
    XCENTER=fix(swidth/2);
    YCENTER=fix(sheight/2);
    %when you leave winRect blank, it just fills the whole screen
    %winRect=[];
    %For running on two monitors
%     [w, wRect]=Screen('OpenWindow', 1, 0,winRect,32,2);  %subj screen
%     [w2, wRect2]=Screen('OpenWindow', 2, 0,winRect,32,2); %experimenter screen
end

ShowHideWinTaskbarMex(1);

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
STIM.trials =24;               %number of trials to run
STIM.kb = -1;                   %determines which keyboard to use
STIM.leftmarg = XCENTER-200;    %Left margin for presenting text. Should be updated to respond to screen size.

%Make stuctures here for i/o data
proDMT = struct;
proDMT.Var.Trial= (1:STIM.trials)'; %makes verticle list of trial number, 1 through STIM.trials
[proDMT.Var.Money_Endowed, proDMT.Var.Mult_Char, proDMT.Var.Observe] = BalanceTrials(STIM.trials,1,[8 16 24],[.75 1 1.25 1.75],[1 2]);
proDMT.Data.ID = repmat(ID,STIM.trials,1);
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
ratings_height=80;

allRects.rate1_coords=[XCENTER-fix(1.5*ratings_spacing),YCENTER+225];
allRects.rate2_coords=[XCENTER-fix(.5*ratings_spacing),YCENTER+225];
allRects.rate3_coords=[XCENTER+fix(.5*ratings_spacing),YCENTER+225];
allRects.rate4_coords=[XCENTER+fix(1.5*ratings_spacing),YCENTER+225];

raterect=[0 0 ratings_width ratings_height];
allRects.rate1rect=CenterRectOnPoint(raterect,allRects.rate1_coords(1),allRects.rate1_coords(2));
allRects.rate2rect=CenterRectOnPoint(raterect,allRects.rate2_coords(1),allRects.rate2_coords(2));
allRects.rate3rect=CenterRectOnPoint(raterect,allRects.rate3_coords(1),allRects.rate3_coords(2));
allRects.rate4rect=CenterRectOnPoint(raterect,allRects.rate4_coords(1),allRects.rate4_coords(2));

%%
%Prosocial Decision Making Task (Pro-DMT)
%Developed by ELK, AKA Ricky DMT.

commandwindow;
ListenChar(2);
HideCursor;
KbName('UnifyKeyNames');

%Pre-load image for observed v. unobserved
open_eye = imread('open_eye.png');
closed_eye = imread('closed_eye.png');
openTexture = Screen('MakeTexture',w,open_eye);
closedTexture = Screen('MakeTexture',w,closed_eye);
openTexture = Screen('MakeTexture',w2,open_eye);
closedTexture = Screen('MakeTexture',w2,closed_eye);
eyeTexture = [openTexture closedTexture];
[imgH, imgW, ~] = size(open_eye);
eye_pp = {'Public' 'Private'};

%Define image rect as  some percent (1/scalefactor) of total screen size
%May not be necessary, but allows eye to be scaled with screen size.
scalefactor = 1;
imgRect = [0 0 imgW/scalefactor imgH/scalefactor];

%set margin border for distance of img from edge of screen
border = 10; 

%Place scaled image in center of rect that is defined by screen size,
%scaled imaged, & border.
scaleRect = [XCENTER-(imgW/2) border XCENTER+(imgW/2) border+imgH];
destRect = CenterRect(imgRect,scaleRect);

%"How much would you like to donate" - Removed from initial location in
%loop.
quest_text = sprintf('How much would you like to donate?');

%%
%Present Instructions

KbReleaseWait;
    
DrawFormattedText(w,'The decision making task is about to begin.\nPress any key to continue.','center','center',COLORS.WHITE,[],[],[],1.25);
Screen('Flip',w);
DrawFormattedText(w2,'The decision making task is about to begin.\nPress any key to continue.','center','center',COLORS.WHITE,[],[],[],1.25);
Screen('Flip',w2);
KbWait;

Screen('Flip',w);
Screen('Flip',w2);

WaitSecs(TIMING.intro);
%%

%Present trials

for trial=1:STIM.trials;
    
    %Use proDMT.Var.Observe to determine observed/eyes or not
    eye = eyeTexture(proDMT.Var.Observe(trial));
    eye_text = eye_pp{proDMT.Var.Observe(trial)};
    
    %Present deal with theDealioDualio function.
    theDealioDualio();
    drawRatings();
    Screen('Flip',w2,[],1);
    sat_startSecs=Screen('Flip',w,[],1);
    
    
    while 1
        [keyisdown, rateResponseSecs, keycode] = KbCheck();

        if (keyisdown==1 && (keycode(KEY.one) || keycode(KEY.two) || keycode(KEY.tres) || keycode(KEY.four)))

            drawRatings(keycode);
            Screen('Flip',w);
            Screen('Flip',w2);
            WaitSecs(.25);
            sat_pressedKey = KbName(find(keycode));
            proDMT.Data.satRate(trial) = str2double(sat_pressedKey(1)); %record satisfaction rating
            proDMT.Data.sat_RT(trial) = rateResponseSecs-sat_startSecs; %record straight to proDMT;
            break
        end
    end
    

    
    %Present deal again with theDealioDualio function;
    theDealioDualio();

%     if proDMT.Var.Observe(trial) ==1;
%         DrawFormattedText(w2,quest_text,'center',YCENTER+75,COLORS.RED);
%     end
    
    Screen('Flip',w2,[],1);
    startSecs = Screen('Flip',w,[],1);  %Start clock for RT.
    
    confirm = 0;  
    while confirm == 0;
        key = GetEchoNumber(w,quest_text,XCENTER-600,YCENTER+100,COLORS.RED,COLORS.BLACK);
        DMT_RT = GetSecs - startSecs;
            
        if isempty(key) || key > proDMT.Var.Money_Endowed(trial) || key < 0;
            
                FlushEvents();
                DrawFormattedText(w,'Invalid Response.','center',YCENTER+100,COLORS.RED);
                Screen('Flip',w);
                WaitSecs(1.5);
                theDealioDualio();
                Screen('Flip',w2,[],1);
                startSecs = Screen('Flip',w,[],1);
            else
                donation = round(key);
                confirm = 1;

        end
    end
    
    %Once participant chooses amount and confirms choice, exit the while
    %loop and record data to proDMT.
    
    %RT
    proDMT.Data.RT(trial) = DMT_RT;
    %Amount donated
    proDMT.Data.Amt_Donated(trial)=donation;
    
    
    %Calculate & record round $ and total in pot
    proDMT.Data.Amt_You(trial) = proDMT.Var.Money_Endowed(trial) - donation;
    proDMT.Data.Amt_Char(trial) = donation * proDMT.Var.Mult_Char(trial);
        
    Screen('Flip',w);
    Screen('Flip',w2);
    WaitSecs(TIMING.feed);

    %Display amounts for round
    amt_you_gave_text = sprintf('You have chosen to give %.2f dollars to FfLC.',donation);
    amt_you_recv_text = sprintf('You received %.2f dollars.',proDMT.Data.Amt_You(trial));
    amt_char_text = sprintf('FfLC received %.2f dollars.',proDMT.Data.Amt_Char(trial));
    DrawFormattedText(w,amt_you_gave_text,'center',YCENTER-100,COLORS.WHITE);
    DrawFormattedText(w,amt_you_recv_text,'center',YCENTER+50,COLORS.GREEN);
    DrawFormattedText(w,amt_char_text,'center',YCENTER-30,COLORS.GREEN);
    Screen('DrawTexture',w,eye,[],destRect);
    
    %Display to experimenters if Trial = observed.
    if proDMT.Var.Observe(trial) == 1;
        DrawFormattedText(w2,amt_you_gave_text,'center',YCENTER-100,COLORS.WHITE);
        DrawFormattedText(w2,amt_you_recv_text,'center',YCENTER+50,COLORS.GREEN);
        DrawFormattedText(w2,amt_char_text,'center',YCENTER-30,COLORS.GREEN);
        Screen('DrawTexture',w2,eye,[],destRect);
    elseif proDMT.Var.Observe(trial) == 2; %if private
        DrawFormattedText(w2,'That some private shit, yo.','center','center',COLORS.ORANGE);
    end
    Screen('Flip',w,[],1);
    Screen('Flip',w2,[],1);
            
    WaitSecs(TIMING.end);
    DrawFormattedText(w,'Press any key to continue.','center',YCENTER+100,COLORS.WHITE);
    DrawFormattedText(w2,'Press any key to continue.','center',YCENTER+100,COLORS.WHITE);
    Screen('Flip',w,[],1);
    Screen('Flip',w2,[],1);
    
    FlushEvents();
    %Press any key;
    KbWait();
    Screen('Flip',w);
    Screen('Flip',w2);
    WaitSecs(1);
end

%Export pro.DMT to text and save with subject number.
%find the mfilesdir by figuring out where show_faces.m is kept
[mfilesdir,name,ext] = fileparts(which('prosocial_task.m'));

%get the parent directory, which is one level up from mfilesdir
[parentdir,~,~] =fileparts(mfilesdir);


%create the paths to the other directories, starting from the parent
%directory
% savedir = [parentdir filesep 'Results\proDMT\'];
savedir = [parentdir filesep 'Results' filesep];

save([savedir 'proDMT_' num2str(ID) '.mat'],'proDMT');

DrawFormattedText(w,'Thank you for participating\n in this part of the study!','center','center',COLORS.WHITE);
Screen('Flip', w);

if w~=w2
    
    DrawFormattedText(w2,'Thank you for participating\n in this part of the study!','center','center',COLORS.WHITE);
    Screen('Flip', w2);
    
end

WaitSecs(5);
Screen('CloseAll');

end
