% jitterfix.m
%
% Author: Cendri Hutcherson
% Date: 2.10.09
%
% Inserts a variable duration fixation point before the trial, to create a
% jittered ITI.

jitterstart = StartTime+2.2+(jitter(trial)); %StartTime+8.25+(trial-1)*12

if jitter(trial) > 0
    % prepare and display jitter fixation
    DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
    jitterstart = Screen(PTBParams.win,'Flip',jitterstart);
end