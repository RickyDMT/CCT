function theDealioDualio(varargin)
%theDealio: Presents offers in Prosocial DMT
%   Call this function in order to present current trial's offer.

global w w2 trial eye destRect proDMT YCENTER COLORS eye_text STIM

mon_you_text = sprintf('You have $%.2f',proDMT.Var.Money_Endowed(trial));
mon_char_text = sprintf('For every dollar you donate, \nFood for Lane County will receive $%.2f',proDMT.Var.Mult_Char(trial));
DrawFormattedText(w,mon_you_text,'center',YCENTER-75,COLORS.WHITE);
DrawFormattedText(w,mon_char_text,'center',YCENTER-25,COLORS.WHITE,[],[],[],1.25);
Screen('DrawTexture',w,eye,[],destRect);
DrawFormattedText(w,eye_text,'center',YCENTER-250,COLORS.WHITE);
%Flipped in main page.

if proDMT.Var.Observe(trial)==1;
    DrawFormattedText(w2,mon_you_text,'center',YCENTER-100,COLORS.WHITE);
    DrawFormattedText(w2,mon_char_text,'center',YCENTER-25,COLORS.WHITE);
    DrawFormattedText(w2,eye_text,'center',YCENTER-250,COLORS.WHITE);
    Screen('DrawTexture',w2,eye,[],destRect);
    %Flipped in main page
elseif proDMT.Var.Observe(trial)==2;
    DrawFormattedText(w2,'This is private.','center','center',COLORS.RED);
end
disp_trial = sprintf('Trial No. %d of %d.',trial,STIM.trials);
DrawFormattedText(w2,disp_trial,'center',YCENTER+200,COLORS.ORANGE);

end

