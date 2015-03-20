function [ telap ] = CountdownClock( tstart,ttotes,rects,varargin )
%CountdownClock Puts a fucking clock on the screen.
%   Detailed explanation goes up yer ass.

global w COLORS

telap = round(toc(tstart)*10)/10;

if telap >= ttotes
    telap = ttotes;
    tleft = 0;
else
    tleft = ttotes - telap;
end

tdisp = sprintf('%02.1f',tleft);

if tleft >8
    DrawFormattedText(w,tdisp,'center',rects(2,end)+45,COLORS.GREEN);
else
    DrawFormattedText(w,tdisp,'center',rects(2,end)+45,COLORS.RED);
end


end

