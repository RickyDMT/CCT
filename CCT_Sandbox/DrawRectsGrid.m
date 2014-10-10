function [ rects ] = DrawRectsGrid(varargin)
%DrawRectGrid:  Builds a grid of rectangles with a gap in between.
%   Future added functionality:  Have it pick colors based on mouse
%   selection.

global DIMS wRect

xcenter = fix(wRect(3)/2);
ycenter = fix(wRect(4)*(2/3));


square_side = 50;
gap = 10;
%DIMS.grid_row = 4;
%DIMS.grid_col = 2;
squart_x = xcenter-((square_side*DIMS.grid_row)+(gap*(DIMS.grid_row-1)))/2;
squart_y = ycenter-((square_side*DIMS.grid_col)+(gap*(DIMS.grid_col-1)))/2;

rects = zeros(4,(DIMS.grid_totes));

for row = 1:DIMS.grid_row;
    for col = 1:DIMS.grid_col;
        currr = ((row-1)*DIMS.grid_col)+col;
        rects(1,currr)= squart_x + (row-1)*(square_side+gap);
        rects(2,currr)= squart_y + (col-1)*(square_side+gap);
        rects(3,currr)= squart_x + (row-1)*(square_side+gap)+square_side;
        rects(4,currr)= squart_y + (col-1)*(square_side+gap)+square_side;
    end
end

% No clicks, please
    rects(1,length(rects)+1)= xcenter - ((2*square_side)+1.5*gap);
    rects(2,length(rects))= squart_y - ((square_side/2)+2*gap);
    rects(3,length(rects))= xcenter - gap/2;
    rects(4,length(rects))= squart_y - 2*gap;
    
% Just end it all!
    rects(1,length(rects)+1)= xcenter + gap/2;
    rects(2,length(rects))= squart_y - ((square_side/2)+2*gap);
    rects(3,length(rects))= xcenter + ((2*square_side)+1.5*gap);
    rects(4,length(rects))= squart_y - 2*gap;

end

