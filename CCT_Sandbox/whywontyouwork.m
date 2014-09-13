global KEY test COLORS

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
COLORS.WHITE=[255 255 255 255];

test = struct;
test.Horz = [];
test.RT = [];

%KbQueueCreate();
%KbQueueStart(-1);

commandwindow;

% for i = 1:2;
%     fprintf('Which key would you like?\n');
%     j=1;
%     confirm = 0;
%     while confirm == 0;
%         confirm2 = 0;
%         %KbQueueStart();
%         [press,~,key] = KbCheck();
%         if press;
%             if find(key) == KEY.nine;
%                 %KbQueueFlush();
%             else
%                 a = KbName(find(key));
%                 test.RT(i,j) = key(find(key));
%                 fprintf('You pressed %s.\n',a);
%                 %KbQueueStop();
%                 %KbQueueFlush();
%                 WaitSecs(2);
%                 fprintf('Did you mean to press %s?\n',a);
%                 %KbQueueStart();
%                 while confirm2==0
%                     [p,k] = KbCheck();
%                     if p && find(k)== KEY.yes;
%                         fprintf('Good I am glad. We can move on.\n');
%                         confirm =1;
%                         confirm2 =1;
%                         j = j+1;
%                         test.Horz(i,j) = k(find(k));
%                         %KbQueueStop();
%                         %KbQueueFlush();
%                     elseif p && find(k)== KEY.no;
%                         fickle; %testing use of function in script
%                         confirm2 =1;
%                         j = j+1;
%                         test.Horz(i,j) = k(find(k));
%                         %KbQueueStop();
%                         %KbQueueFlush();
%                     end                     
%                 end
%             end
%         end
%     end
% end

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
%you can set the font sizes and styles here
Screen('TextFont', w, 'Arial');
Screen('TextStyle', w, 1);
Screen('TextSize',w,20);

DrawFormattedText(w,'How many bugs in a box?','center','center',COLORS.WHITE);
Screen('Flip',w,[],1);
    
% restrict = [KEY.one KEY.two KEY.tres];
% RestrictKeysForKbCheck(restrict);

% KbName('UnifyKeyNames');
% for i = 1:2;
%     www = 0;
%     fprintf('Which key would you like?\n');
%     WaitSecs(1);
%     FlushEvents();
%    while www ==0;
%     [press,secs,key] = KbCheck();
%         if press ==1;
%             a = KbName(find(key));
%             fprintf('You pressed %s.\n',a);
%             www = 1;
%         end
%    end
%        
% %         rtext = sprintf('You pressed %s.\n',a);
% %         DrawFormattedText(w,rtext,'center','center',COLORS.WHITE);
% %         Screen('Flip',w);
% %         WaitSecs(1);
%         FlushEvents();
% end
% RestrictKeysForKbCheck();
% 
% 
%  while 1 %waits for any key
%         [Down Secs Code] = KbCheck();
%         if Down == 1
%             break;
%         end
%end
%     
% 
KbName('UnifyKeyNames');
FlushEvents();
ListenChar(2);
data = zeros(3,1);              

for xxx = 1:3;
    value = GetEchoNumber(w,'How many?',XCENTER-100,YCENTER+100,COLORS.WHITE,[0 0 0 255]);
    
        textresp = sprintf('You typed %d.',value);
       DrawFormattedText(w,textresp,'center',YCENTER-100,COLORS.WHITE);
       Screen('Flip',w); 
       WaitSecs(1);
       FlushEvents();

%     if value == 99;
%         DrawFormattedText(w,'Goodbye.','center',YCENTER-100,COLORS.WHITE);
%         Screen('Flip',w);
%         WaitSecs(1);
%         break
    if isempty(value);
        DrawFormattedText(w,'That is NaN. Thanks for nothing.','center',YCENTER-100,COLORS.WHITE);
        Screen('Flip',w);
        WaitSecs(1);
    else
        data(xxx,1) = value;
        DrawFormattedText(w,'Thank you for your donation.','center',YCENTER-100,COLORS.WHITE);
        Screen('Flip',w);
        WaitSecs(1); 
    end
%        
%     elseif value > 16
%        DrawFormattedText(w,'You have the heebeejeebies!','center',YCENTER-100,COLORS.WHITE);
%        Screen('Flip',w); 
%        WaitSecs(1);
%        FlushEvents();
%        Screen('Flip',w);
%     elseif value <= 16
%         DrawFormattedText(w,'I am disappoint.','center',YCENTER-100,COLORS.WHITE);
%         Screen('Flip',w);
%         WaitSecs(1);
%         Screen('Flip',w);
%     else
%         DrawFormattedText(w,'I NEED NUMBER.','center',YCENTER-100,COLORS.WHITE);
%         Screen('Flip',w);
%         WaitSecs(1);
%         Screen('Flip',w);
%         break
%     end
end

ListenChar(1);

sca
