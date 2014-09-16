function [ telap ] = CountdownClock( tstart,ttotes,varargin )
%CountdownClock Puts a fucking clock on the screen.
%   Detailed explanation goes up yer ass.

global w COLORS

telap = round(toc(tstart));
tleft = ttotes - telap;
tdisp = sprintf('%02.0f',tleft); %NEED CHANGE: Add decimals!
DrawFormattedText(w,tdisp,'center',20,COLORS.RED);


end

