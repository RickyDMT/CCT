function [ varargout ] = DrawImageRects( clicked, varargin )
%DoDrawCardImage(clicked)  Draw gain/loss images on cards.

global rects fail_list

%bring in "clicked" array of cards that have been clicked.

if nargin == 1;
    if any(clicked)
        imagerects = rects(:,clicked==1);
        varargout{1} = imagerects;
    end
elseif nargin == 2;
    imagerects_fail = rects(:,fail_list);
    imagerects = rects(:,1:length(clicked));
    imagerects(:,fail_list) = [];
%     for n_out = 1:nargout;
        varargout{1} = imagerects;
        varargout{2} = imagerects_fail;
    
end



end

