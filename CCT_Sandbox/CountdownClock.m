function [ telap ] = CountdownClock( tstart,ttotes,varargin )
%CountdownClock Puts a fucking clock on the screen.
%   Detailed explanation goes up yer ass.

global w COLORS

telap = round(toc(tstart)*10)/10;
tleft = ttotes - telap;
tdisp = sprintf('%02.1f',tleft); %NEED CHANGE: Add decimals!
if tleft >8
    DrawFormattedText(w,tdisp,'center',20,COLORS.GREEN);
else
    DrawFormattedText(w,tdisp,'center',20,COLORS.RED);
end

end

