global KEY COLORS XCENTER YCENTER allRects
%%

%change this to 0 to fill whole screen
DEBUG=1;

if DEBUG
    %create a rect for the screen
    winRect=[0 0 640 480];
    %establish the center points
    XCENTER=320;
    YCENTER=240;
else
    %change screen resolution
    Screen('Resolution',0,1024,768,[],32);
    
    %when you leave winRect blank, it just fills the whole screen
    winRect=[];
end

%set up the screen and dimensions

%list all the screens, then just pick the last one in the list (if you have
%only 1 monitor, then it just chooses that one)
screenNumber=max(Screen('Screens'));

%open a window on that monitor. 32 refers to 32 bit color depth (millions of
%colors), winRect will either be a 1024x768 box, or the whole screen. The
%function returns a window "w", and a rect that represents the whole
%screen. 
[w, wRect]=Screen('OpenWindow', screenNumber, 0,winRect,32,2);

%this gives the x and y dimensions of our screen, in pixels. 
[swidth, sheight] = Screen('WindowSize', screenNumber);
% XCENTER=fix(swidth/2)
% YCENTER=fix(sheight/2)

%you can set the font sizes and styles here
Screen('TextFont', w, 'Arial');
Screen('TextStyle', w, 1);
Screen('TextSize',w,20);

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
%%
%Pre-load image for observed v. unobserved
open_eye = imread('open_eye.png');
%closed_eye = imread('closed_eye.png');
openTexture = Screen('MakeTexture',w,open_eye);
%closedTexture = Screen('MakeTexture',w,closed_eye);
%eyeTexture = [openTexture closedTexture];
[imgH, imgW, ~] = size(open_eye);
%eye_pp = {'Public' 'Private'};
eye = openTexture;

i=1;
%Define image rect as  some percent (1/scalefactor) of total screen size
%May not be necessary, but allows eye to be scaled with screen size.
%Figure out WTF is wrong with the horizontal dimension.
scalefactor = 5;
imgRect = [0 0 imgW/scalefactor imgH/scalefactor];
badRect = wRect/scalefactor;

%set margin border for distance of img from edge of screen
border = 10; 

%Place scaled image in center of rect that is defined by screen size,
%scaled imaged, & border.
scaleRect = [XCENTER-(imgW/2) border XCENTER+(imgW/2) border+imgH];
badscaleRect = [XCENTER-(imgW/2) YCENTER XCENTER+(imgW/2) YCENTER+imgH];
%scaleRect = [XCENTER-(imgRect(3)) border XCENTER+(imgRect(3)) border+imgRect(4)];
%scaleRect = [wRect(3)-imgRect(3)-border border wRect(3)-border border+imgRect(4)];
destRect = CenterRect(imgRect,scaleRect);
baddestRect = CenterRect(badRect, badscaleRect);

Screen('DrawTexture',w,eye,[],destRect);
Screen('DrawTexture',w,eye,[],baddestRect);
Screen('Flip',w);
WaitSecs(1);

theDealio(w, i, eye, destRect, proDMT, YCENTER, COLORS, TIMING, eye_text, allRects);

%ask for rating of satisfaction1
%Screen('TextSize',w,45);
DrawFormattedText(w,'How satisfied are you?','center',YCENTER+100,COLORS.WHITE);
%drawPhotoAndOptions(Phase1.SubjectPhoto,select);
drawRatings();
%drawStatus(trial);
%drawObserve(trial);
ratingsOnset=Screen('Flip', w);

%ratingsOnset=ratingsOnset-TIME_BASELINE;

%wait for response, display visual feedback for .25s

startsecs=GetSecs;

while 1
    [keyisdown, rateResponseSecs, keycode] = KbCheck();
    
    if (keyisdown==1 && (keycode(KEY.one) || keycode(KEY.two) || keycode(KEY.tres) || keycode(KEY.four)))
       
        %drawPhotoAndOptions(Phase1.SubjectPhoto,select);
        %Screen('TextSize',w,45);
        DrawFormattedText(w,'How satisfied are you?','center',YCENTER+100,COLORS.WHITE);
        drawRatings(keycode);
        %drawStatus(trial);
        %drawObserve(trial);
        Screen('Flip',w);
        WaitSecs(.25);
        %rateResp= rateResponseSecs-TIME_BASELINE;
        %rt=rateResponseSecs-startsecs;
        break;
    end
end



Screen('CloseAll');


