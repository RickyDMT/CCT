function [ telap ] = CountdownClock( tstart,ttotes,varargin )
%CountdownClock Puts a fucking clock on the scren.
%   Detailed explanation goes up yer ass.

global w COLORS

telap = round(toc(tstart));
tleft = ttotes - telap;
tdisp = sprintf('%02.0f',tleft);
DrawFormattedText(w,tdisp,'center',20,COLORS.RED);
%Screen('Flip',w);

end

