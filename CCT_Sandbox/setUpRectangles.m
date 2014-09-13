function allRects=setUpRectangles()
global DIMS;


%%

XCENTER=DIMS.XCENTER;
YCENTER=DIMS.YCENTER;
yshift=160;

% photosize=size(photo);
photosize=[225 216];

allRects.photo_coords=[XCENTER,(photosize(2)/2)+40+yshift];


% This is where the status information will be drawn
allRects.status_coords=[XCENTER,(photosize(2)/2)-85+yshift-40];

% This is where the observe stimulus will be drawn
% allRects.observe_coords=[134,91];
allRects.observe_coords=[XCENTER,(photosize(2)/2)-75];




ratings_spacing=150;
ratings_width=100;
ratings_height=70;

allRects=structure;
allRects.rate1_coords=[XCENTER-fix(1.5*ratings_spacing),YCENTER+100+yshift];
allRects.rate2_coords=[XCENTER-fix(.5*ratings_spacing),YCENTER+100+yshift];
allRects.rate3_coords=[XCENTER+fix(.5*ratings_spacing),YCENTER+100+yshift];
allRects.rate4_coords=[XCENTER+fix(1.5*ratings_spacing),YCENTER+100+yshift];

raterect=[0 0 ratings_width ratings_height];
allRects.rate1rect=CenterRectOnPoint(raterect,allRects.rate1_coords(1),allRects.rate1_coords(2));
allRects.rate2rect=CenterRectOnPoint(raterect,allRects.rate2_coords(1),allRects.rate2_coords(2));
allRects.rate3rect=CenterRectOnPoint(raterect,allRects.rate3_coords(1),allRects.rate3_coords(2));
allRects.rate4rect=CenterRectOnPoint(raterect,allRects.rate4_coords(1),allRects.rate4_coords(2));

photorect=[0 0 photosize(2) photosize(1)];
allRects.photorect=CenterRectOnPoint(photorect,allRects.photo_coords(1),allRects.photo_coords(2));

options_linespacing=35;
options_width=225;

allRects.option1_coords=[XCENTER, allRects.photorect(4)+20];
allRects.option2_coords=[XCENTER, allRects.photorect(4)+20+options_linespacing];


option1rect=[0 0 options_width options_linespacing];
allRects.option1rect=CenterRectOnPoint(option1rect,allRects.option1_coords(1),allRects.option1_coords(2));
option2rect=[0 0 options_width options_linespacing];
allRects.option2rect=CenterRectOnPoint(option2rect,allRects.option2_coords(1),allRects.option2_coords(2));


choices_width=325;
choices_height=75;
choices_spacing=10;

allRects.leftchoice_coords=[XCENTER-fix(choices_width/2)-choices_spacing, allRects.option2_coords(2)+choices_height+10];
allRects.rightchoice_coords=[XCENTER+fix(choices_width/2)+choices_spacing,allRects.option2_coords(2)+choices_height+10];


leftchoicerect=[0 0 choices_width choices_height];
allRects.leftchoicerect=CenterRectOnPoint(leftchoicerect,allRects.leftchoice_coords(1),allRects.leftchoice_coords(2));

rightchoicerect=[0 0 choices_width choices_height];
allRects.rightchoicerect=CenterRectOnPoint(rightchoicerect,allRects.rightchoice_coords(1),allRects.rightchoice_coords(2));


eq_width=250;
eq_height=100;
allRects.eq_coords=[XCENTER YCENTER+20+yshift];

eqRect=[0 0 eq_width eq_height];
allRects.eqrect=CenterRectOnPoint(eqRect,allRects.eq_coords(1),allRects.eq_coords(2));

resprect_width=200;
resprect_height=80;
resprect_spacing=100;

allRects.resprectleft_coords=[XCENTER-(resprect_width/2)-(resprect_spacing/2),allRects.eq_coords(2)+(eq_width/2)+15];
allRects.resprectright_coords=[XCENTER+(resprect_width/2)+(resprect_spacing/2),allRects.eq_coords(2)+(eq_width/2)+15];


resprect=[0 0 resprect_width resprect_height];
allRects.falseRect_left=CenterRectOnPoint(resprect,allRects.resprectleft_coords(1),allRects.resprectleft_coords(2));
allRects.trueRect_right=CenterRectOnPoint(resprect,allRects.resprectright_coords(1),allRects.resprectright_coords(2));



end