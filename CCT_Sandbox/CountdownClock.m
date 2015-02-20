function [ telap ] = CountdownClock( tstart,ttotes, rects, varargin )
%CountdownClock Puts a fucking clock on the screen.
%   Detailed explanation goes up yer ass.

global w COLORS

telap = round(toc(tstart)*10)/10;
tleft = ttotes - telap;
tdisp = sprintf('%02.1f',tleft); 
DrawFormattedText(w,tdisp,'center',rects(2,end)+45,COLORS.RED);


end

