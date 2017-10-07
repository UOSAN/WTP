% scantrig.m
%
% Author: Cendri Hutcherson
% Modified by: Dani Cosme
% Last Modified: 4-22-2015
%
% Wait for ' from scanner to begin the experiment.

KbTriggerWait(PTBParams.keys.trigger,inputDevice); % note: no problems leaving out 'inputDevice' in the mock, but MUST INCLUDE FOR SCANNER
disabledTrigger = DisableKeysForKbCheck(PTBParams.keys.trigger);
StartTime = GetSecs;
    
DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
Screen(PTBParams.win,'Flip');