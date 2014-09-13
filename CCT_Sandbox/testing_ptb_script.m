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

%establish colors [r g b opacity]
white=[255 255 255 255];
black=[0 0 0 255];
red = [255 0 0 255];
green = [0 255 0 255];
blue = [0 0 255 255];


while 1
    Screen('DrawText',w,'Fuck you.',XCENTER,YCENTER,green);
    Screen('Flip',w,[],1);
    WaitSecs(1);
    Screen('DrawText',w,'No, fuck you.',XCENTER,YCENTER+50,red);
    Screen('Flip',w,[],1);


    WaitSecs(1);
    Screen('DrawText',w,'I am glad we agree.',XCENTER,YCENTER+150,blue);
    Screen('Flip',w);
    WaitSecs(1);
    Screen('Flip',w,[],1);
    WaitSecs(.5);
end


    keysofinterest = zeros(1,256);
    keylist = [KEY.zero KEY.one KEY.two KEY.tres KEY.four KEY.five KEY.six KEY.sev KEY.eight KEY.nine];
    keysofinterest(keylist)=1;
    KbQueueCreate([],keysofinterest);
    KbQueueStart();
for i=1:10;
    [press, first]=KbQueueCheck();
    if press;
        a =sprintf('Oh so you like the %s key. Fuck you.',KbName(first));
        Screen('DrawText',w,a);
        Screen('Flip',w);
        WaitSecs(2);
        Screen('Flip',w);
        KbQueueFlush();
    end
end

%Screen('DrawText',w,'Donate $ to FfLC?',XCENTER-200,YCENTER,green);
%Screen('Flip',w);

while 1
    % Check the queue for key presses.
    [pressed, firstPress]=KbQueueCheck();

    % If the user has pressed a key, then display its code number and name.
    if pressed

        % Note that we use find(firstPress) because firstPress is an array with
        % zero values for unpressed keys and non-zero values for pressed keys
        %
        % The fprintf statement implicitly assumes that only one key will have
        % been pressed. If this assumption is not correct, an error will result

        fprintf('You pressed key %i which is %s\n', find(firstPress), KbName(firstPress));

        if firstPress(escapeKey)
            break;
        end
    end
end
KbQueueRelease();
return



testval = 8;
numonly = [1:29,40:256];
DisableKeysForKbCheck(numonly);
Screen('DrawText',w,'Donate $ to FfLC?',XCENTER-200,YCENTER,green);
Screen('Flip',w);
    
    
while 1
    [keyisdown, responseSecs, keycode] = KbCheck();
    if keyisdown == 1
        pressedKey = KbName(find(keycode));
        pressedNum = str2num(pressedKey(1));
        if pressedNum <= testval;
            break;
        else
            keyisdown = 0;
        end
    end
end

Screen('Flip',w);
WaitSecs(1);
         pressedKey = KbName(find(keycode));
         pressedNum = str2num(pressedKey(1));
         
amount = sprintf('You have chosen %.2f dollars to FfLC.',pressedNum);
Screen('DrawText',w,amount,XCENTER-200,YCENTER,green);
Screen('Flip',w);

%if we set up width and height here, then it's easy to change the shape of
%everything later. 
rect_width=100;
rect_height=100;

%first create a rect
%coordinates are: [topLeftX topLeftY lowerRightX lowerRightY];
temprect=[0 0 rect_width rect_height];

%then center it in the center of the screen
rect1=CenterRectOnPoint(temprect,XCENTER,YCENTER);

%you can create a duplicate rect by reusing temprect
rect2 = CenterRectOnPoint(temprect,XCENTER,YCENTER+150);


%now actually put the rects on the screen
%Screen('FrameRect',window,color,the_rect,line_width);
Screen('FrameRect',w,white,rect1,4);
Screen('FrameRect',w,white,rect2,4);

smallrect=[0 0 rect_width*.50 rect_height*.50];
smallrect=CenterRectOnPoint(smallrect,XCENTER,YCENTER);

%draw the smaller rect on the screen, but filled in this time. 
Screen('FillRect',w,red,smallrect);


%draw some text. Screen('DrawText',window,the_text,x,y,color);
%x and y establish the upper-left of the text?
Screen('DrawText',w,'Here is Some text!!!',XCENTER-250,YCENTER-100,white);

%now 'Flip' to actually present things on the screen. 
Screen('Flip',w);




%%

%to show some timing stuff...
Time_baseline=GetSecs;

WaitSecs(.5)



%if you call 'FillRect' or 'FrameRect' and don't give it a specific rect,
%it will just fill the whole screen.
Screen('FillRect',w,black);
Screen('FrameRect',w,red,[],8);

%DrawFormattedText is better for centering text..
DrawFormattedText(w,'+','center','center',white);

%THIS FUNCTION CREATED BY JASON, NEEDS TO BE IN PATH
CenterTextOnPoint(w,'Centered on a weird spot',100,200,blue);

%if you need a timestamp of stimulus onset, Screen('Flip',w) also returns a
%timestamp when it is run. 

stimonset=Screen('Flip',w);

%timestamps are meaningless on their own, they ALWAYS need to be in
%reference to a baseline. 

%we left of the semicolon, so it will spit out into the command window
onset_time=stimonset-Time_baseline

%%
green = [0 255 0 255]

Screen('TextSize',w,30);

temprect=[0 0 rect_width rect_height];

%then center it in the center of the screen
rect1=CenterRectOnPoint(temprect,XCENTER/2,YCENTER);

%you can create a duplicate rect by reusing temprect
rect2 = CenterRectOnPoint(temprect,XCENTER/2+XCENTER,YCENTER);
DrawFormattedText(w,'+','center','center',white);
Screen('FrameRect',w,white,rect1,4);
Screen('FillRect',w,green,rect2,4);
Screen('FrameRect',w,white,rect2,4);
CenterTextOnPoint(w,'Left',XCENTER/2,YCENTER,white);
CenterTextOnPoint(w,'Right',XCENTER+XCENTER/2,YCENTER,white);
Screen('Flip',w);

%%

%%

WaitSecs(1.0);

%circles work the same way as rectangles. 
%you still create a "rect" to represent it, but just use Screen('FillOval')
%or Screen('FrameOval') to make a circle. 
%rect1 is the rect that we created above

%another blank screen
Screen('FillRect',w,black);

Screen('FrameOval',w,white,rect1,4);
Screen('FillOval',w,red,smallrect);

Screen('Flip',w);



%%

%shut everything down. 
Screen('CloseAll'); %you can also just type "sca" and it does the same thing