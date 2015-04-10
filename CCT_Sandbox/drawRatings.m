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
   

Screen('TextFont', window, 'Arial');
Screen('TextStyle', window, 1);
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