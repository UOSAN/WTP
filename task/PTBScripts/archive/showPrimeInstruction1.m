% showInstruction.m
%
% Author: Cendri Hutcherson
% Date: 9.16.08
%
% Description: Shows bmp file of instruction, and waits for user to press
% any key to continue.
insrx = insrx+1;

InsrxScreen = imread([homepath 'Instructions/Slide' sprintf('%02.0f',insrx) '.bmp'], 'BMP');
textureIndex=Screen('MakeTexture',PTBParams.win,InsrxScreen);

eval(['PrimePic = Prime' num2str(m) 'Pic;']);
Screen('DrawTexture',PTBParams.win,PrimePic);
Screen('DrawTextures',PTBParams.win,[textureIndex,PrimePic],[],...
    [findPicLoc(size(InsrxScreen),[.5,.5],PTBParams,'ScreenPct',1);...
    findPicLoc(size(PrimePic),[.5,.19],PTBParams,'ScreenPct',.1)]');

Screen(PTBParams.win,'Flip');
Screen('Close',textureIndex);

while KbCheck
end

keyIsDown = 0;
while keyIsDown == 0
    keyIsDown = KbCheck;
end