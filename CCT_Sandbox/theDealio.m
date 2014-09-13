function theDealio(varargin)

global w trial eye destRect proDMT YCENTER COLORS eye_text

%theDealio: Presents offers in Prosocial DMT
%   Call this function in order to present current trial's offer.

Screen('Flip',w);
mon_you_text = sprintf('You have $%.2f',proDMT.Var.Money_Endowed(trial));
mon_char_text = sprintf('For every dollar you donate, \nFood for Lane County will receive $%.2f',proDMT.Var.Mult_Char(trial));
%quest_text = sprintf('How much would you like to donate?');
DrawFormattedText(w,mon_you_text,'center',YCENTER-75,COLORS.WHITE);
DrawFormattedText(w,mon_char_text,'center',YCENTER-25,COLORS.WHITE);
Screen('DrawTexture',w,eye,[],destRect);
DrawFormattedText(w,eye_text,'center',YCENTER-150,COLORS.WHITE);
%Screen('Flip',w,[],1);
%WaitSecs(TIMING.quest);
%drawRating()
%wait here for rating, then present donation question.
%DrawFormattedText(w,quest_text,'center',YCENTER+25,COLORS.RED);
%Screen('Flip',w,[],1);
    
end

