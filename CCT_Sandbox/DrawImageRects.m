function [ varargout ] = DrawImageRects( clicked, varargin )
%Gives location for gain/loss images on cards.
%If calling function for apocolyptic "end of trial" big reveal, then call
%with "1" as a second input in addition to "clicked" (the cards that have
%been clicked

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

