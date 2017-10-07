%% bidTest.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Cendri Hutcherson
% Modified by: Dani Cosme
% Last Modified: 10-06-2017
%
% Description: Check to make sure participant correctly understands BDM
% instructions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run instructions test
% Set instruction number (defined in runMoney_practice.m)
insrx = insrx + 1; 

InsrxScreen = imread([homepath 'Instructions/Slide' sprintf('%02.0f',insrx) '.bmp'], 'BMP');
textureIndex=Screen('MakeTexture',PTBParams.win,InsrxScreen);

% Resize instruction screen to minimize distortion in the image
imageDims = size(InsrxScreen);
minResizeFactor = min([PTBParams.rect(4)/imageDims(1),PTBParams.rect(3)/imageDims(2)]);

xOffset = floor((PTBParams.rect(3) - imageDims(2) * minResizeFactor)/2);
yOffset = floor((PTBParams.rect(4) - imageDims(1) * minResizeFactor)/2);
destRect = [xOffset, ...
            yOffset, ...
            xOffset + imageDims(2) * minResizeFactor,...
            yOffset + imageDims(1) * minResizeFactor];

% Draw the image
Screen('DrawTexture',PTBParams.win,textureIndex,[],destRect);
Screen(PTBParams.win,'Flip');
Screen('Close',textureIndex);

% Wait for response
while KbCheck(inputDevice)
end
keyWait = 0;
while keyWait == 0
    [keyDown, secs, key] = KbCheck(inputDevice);
    Resp = 0;
    Correct = 0;
    if keyDown == 1
        Resp = KbName(find(key==1));
        Resp = Resp(1);
        if PTBParams.inMRI == 1 %In the scanner use 56, if outside use 12
            if Resp=='5' || Resp=='6'
               keyWait = 1;
            end
        else
            if Resp=='1' || Resp=='2'
               keyWait = 1;
            end
        end
    end
end

if Resp == '2' || Resp == '6'
    CorrectionText = 'CORRECT';
else
    CorrectionText = 'INCORRECT';
end

% Set instruction number (defined in runMoney_practice.m)
insrx = insrx + 1;

InsrxScreen = imread([homepath 'Instructions/Slide' sprintf('%02.0f',insrx) '.bmp'], 'BMP');
textureIndex=Screen('MakeTexture',PTBParams.win,InsrxScreen);

% Resize instruction screen to minimize distortion in the image
imageDims = size(InsrxScreen);
minResizeFactor = min([PTBParams.rect(4)/imageDims(1),PTBParams.rect(3)/imageDims(2)]);

xOffset = floor((PTBParams.rect(3) - imageDims(2) * minResizeFactor)/2);
yOffset = floor((PTBParams.rect(4) - imageDims(1) * minResizeFactor)/2);
destRect = [xOffset, ...
            yOffset, ...
            xOffset + imageDims(2) * minResizeFactor,...
            yOffset + imageDims(1) * minResizeFactor];
        
% Draw the image
Screen('DrawTexture',PTBParams.win,textureIndex, [],destRect);
DrawFormattedText(PTBParams.win,CorrectionText,'center',PTBParams.ctr(2)-.5*PTBParams.ctr(2),[255 0 0]);
Screen(PTBParams.win,'Flip');
Screen('Close',textureIndex);

% Wait for response
while KbCheck(inputDevice)
end

keyIsDown = 0;
while keyIsDown == 0
    keyIsDown = KbCheck(inputDevice);
end

% Set instruction number (defined in runMoney_practice.m)
insrx = insrx + 1;

InsrxScreen = imread([homepath 'Instructions/Slide' sprintf('%02.0f',insrx) '.bmp'], 'BMP');
textureIndex=Screen('MakeTexture',PTBParams.win,InsrxScreen);

% Resize instruction screen to minimize distortion in the image
imageDims = size(InsrxScreen);
minResizeFactor = min([PTBParams.rect(4)/imageDims(1),PTBParams.rect(3)/imageDims(2)]);

xOffset = floor((PTBParams.rect(3) - imageDims(2) * minResizeFactor)/2);
yOffset = floor((PTBParams.rect(4) - imageDims(1) * minResizeFactor)/2);
destRect = [xOffset, ...
            yOffset, ...
            xOffset + imageDims(2) * minResizeFactor,...
            yOffset + imageDims(1) * minResizeFactor];
        
% Draw image
Screen('DrawTexture',PTBParams.win,textureIndex, [],destRect);
Screen(PTBParams.win,'Flip');
Screen('Close',textureIndex);

% Wait for response
while KbCheck(inputDevice)
end
keyWait = 0;
while keyWait == 0
    [keyDown secs key] = KbCheck(inputDevice);
    Resp = 0;
    Correct = 0;
    if keyDown == 1
        Resp = KbName(find(key==1));
        Resp = Resp(1);
        if PTBParams.inMRI == 1 %In the scanner use 56, if outside use 12
            if Resp=='5' || Resp=='6'
               keyWait = 1;
            end
        else
            if Resp=='1' || Resp=='2'
               keyWait = 1;
            end
        end
    end
end

if Resp == '1' || Resp == '5'
    CorrectionText = 'CORRECT';
else
    CorrectionText = 'INCORRECT';
end

% Set instruction number (defined in runMoney_practice.m)
insrx = insrx + 1;

InsrxScreen = imread([homepath 'Instructions/Slide' sprintf('%02.0f',insrx) '.bmp'], 'BMP');
textureIndex=Screen('MakeTexture',PTBParams.win,InsrxScreen);

% Resize instruction screen to minimize distortion in the image
imageDims = size(InsrxScreen);
minResizeFactor = min([PTBParams.rect(4)/imageDims(1),PTBParams.rect(3)/imageDims(2)]);

xOffset = floor((PTBParams.rect(3) - imageDims(2) * minResizeFactor)/2);
yOffset = floor((PTBParams.rect(4) - imageDims(1) * minResizeFactor)/2);
destRect = [xOffset, ...
            yOffset, ...
            xOffset + imageDims(2) * minResizeFactor,...
            yOffset + imageDims(1) * minResizeFactor];
        
% Draw image
Screen('DrawTexture',PTBParams.win,textureIndex, [],destRect);
DrawFormattedText(PTBParams.win,CorrectionText,'center',PTBParams.ctr(2)-.5*PTBParams.ctr(2),[255 0 0]);
Screen(PTBParams.win,'Flip');
Screen('Close',textureIndex);

% Wait for response
while KbCheck(inputDevice)
end

keyIsDown = 0;
while keyIsDown == 0
    keyIsDown = KbCheck(inputDevice);
end
