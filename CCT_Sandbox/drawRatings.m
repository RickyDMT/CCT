function drawRatings(varargin)

global w w2 trial proDMT allRects KEY COLORS YCENTER;


% ratings_spacing=150;
% ratings_width=70;
% ratings_height=40;
% 
% allRects.rate1_coords=[XCENTER-fix(1.5*ratings_spacing),YCENTER+125];
% allRects.rate2_coords=[XCENTER-fix(.5*ratings_spacing),YCENTER+125];
% allRects.rate3_coords=[XCENTER+fix(.5*ratings_spacing),YCENTER+125];
% allRects.rate4_coords=[XCENTER+fix(1.5*ratings_spacing),YCENTER+125];
% 
% raterect=[0 0 ratings_width ratings_height];
% allRects.rate1rect=CenterRectOnPoint(raterect,allRects.rate1_coords(1),allRects.rate1_coords(2));
% allRects.rate2rect=CenterRectOnPoint(raterect,allRects.rate2_coords(1),allRects.rate2_coords(2));
% allRects.rate3rect=CenterRectOnPoint(raterect,allRects.rate3_coords(1),allRects.rate3_coords(2));
% allRects.rate4rect=CenterRectOnPoint(raterect,allRects.rate4_coords(1),allRects.rate4_coords(2));

%Screen('TextFont', w, 'Arial');
%Screen('TextStyle', w, 1)
%Screen('TextSize',w,30);

colors=repmat(COLORS.WHITE',1,4);
rects=horzcat(allRects.rate1rect',allRects.rate2rect',allRects.rate3rect',allRects.rate4rect');


if ~isempty(varargin)
    response=varargin{1};
    
    key=find(response);
    if length(key)>1
        key=key(1);
    end;
    
    switch key
        
        case {KEY.one}
            choice=1;
        case {KEY.two}
            choice=2;
        case {KEY.tres}
            choice=3;
        case {KEY.four}
            choice=4;
    end

    colors(:,choice)=COLORS.GREEN';
    
end

%change fontsize
oldSize = Screen('TextSize',w,36);

%draw all the squares
Screen('FrameRect',w,colors,rects,1);

Screen('TextSize',w);
Screen('TextSize',w2)

%draw the text (1-4)
CenterTextOnPoint(w,'1',allRects.rate1_coords(1),allRects.rate1_coords(2),colors(:,1));
CenterTextOnPoint(w,'2',allRects.rate2_coords(1),allRects.rate2_coords(2),colors(:,2));
CenterTextOnPoint(w,'3',allRects.rate3_coords(1),allRects.rate3_coords(2),colors(:,3));
CenterTextOnPoint(w,'4',allRects.rate4_coords(1),allRects.rate4_coords(2),colors(:,4));

DrawFormattedText(w,'How satisfied are you with this deal?','center',YCENTER+100,COLORS.WHITE);

%Need to update coordinates for monitor.
if exist('w2','var')==1;
    if proDMT.Var.Observe(trial) == 1;
        CenterTextOnPoint(w2,'1',allRects.rate1_coords(1),allRects.rate1_coords(2),colors(:,1));
        CenterTextOnPoint(w2,'2',allRects.rate2_coords(1),allRects.rate2_coords(2),colors(:,2));
        CenterTextOnPoint(w2,'3',allRects.rate3_coords(1),allRects.rate3_coords(2),colors(:,3));
        CenterTextOnPoint(w2,'4',allRects.rate4_coords(1),allRects.rate4_coords(2),colors(:,4));
        DrawFormattedText(w2,'How satisfied are you with this deal?','center',YCENTER+50,COLORS.WHITE);
    end
end


%change font back to whatever it was
Screen('TextSize',w,oldSize);
end