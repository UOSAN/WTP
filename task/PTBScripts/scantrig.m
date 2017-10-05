% scantrig.m
%
% Author: Cendri Hutcherson
% Date: 2.10.09
%
% 4/22/15: edited to change scan trigger to ' for LCNI
%
% Wait for '5' from scanner to begin the experiment.  Note that you still
% need to specify n-extra TRs at the beginning to allow for magnet 
% equilibration

KbTriggerWait(PTBParams.keys.trigger,inputDevice); % note: no problems leaving out 'inputDevice' in the mock, but MUST INCLUDE FOR SCANNER
disabledTrigger = DisableKeysForKbCheck(PTBParams.keys.trigger);
StartTime = GetSecs;
    
DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
Screen(PTBParams.win,'Flip');

%%Original Code
% FlushEvents('keyDown');
% done = 0;
% 	while done == 0
% 		av = CharAvail();
% 		if av ~= 0
% 			if str2double(GetChar()) == 'space' %5
% 				done = 1;
% 				StartTime = GetSecs();
% 			end
% 		end
%     end
%     