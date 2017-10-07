%% Willingness to Pay task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Cendri Hutcherson
% Modified by: Dani Cosme
% Last Modified: 10-06-2017
%
% Description: This script runs the task. You will be prompted to specify
% which version of the task you'd like to run (MRI, behavioral). 
% 
% You do not need to run the initial setup (InitPTB.m).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initial setup for PsychToolbox, using InitPTB.m
clear all;

pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));
PTBParams = InitPTB(homepath);

%% Preload Stimulus Pictures 
% Load food bitmaps into memory
bmps = dir(fullfile(homepath, 'foodpics'));

for x = 1:length(bmps)
    y(x) = ~isempty(regexp(bmps(x).name,'\w*bmp$','match'));
end

bmps = bmps(y);

for x = 1:length(bmps)
    FoodBmp{x} = imread([homepath 'foodpics/' bmps(x).name],'bmp');
end

% Randomize food order
Food = randperm(length(FoodBmp));
    
%% Load bid key bitmap into memory
BidKeyPic = imread(fullfile(homepath, 'BidKeys.bmp'),'BMP');

%% Paint bid key bitmap into offscreen palettes
KeyLegend = Screen('MakeTexture',PTBParams.win,BidKeyPic);

%% Setup jitter
Jitter = jitter(2,60,1); 

%% Initialize keys
inputDevice = PTBParams.keys.deviceNum;

%% Load task instructions based on MRI or behavioral session
if PTBParams.inMRI == 1
    DrawFormattedText(PTBParams.win,'Calibrating scanner.\n\n Please hold very still.','center','center',PTBParams.white);
else 
    DrawFormattedText(PTBParams.win,'The task is about to begin.\n\n Get ready!','center','center',PTBParams.white);
end
Screen(PTBParams.win,'Flip');

%% Run task and log data
% Wait for the trigger before continuing
% Wait for a 'spacebar' to start the behavioral version, and an ' for the scanner version
scantrig; 
logData(PTBParams.datafile,1,StartTime,Jitter);

% Run task
for trial = 1:60 %num trials
    bidFood
    BidWait = 4;
        if PTBParams.inMRI == 1 %In the scanner use 56789, if outside use 123456
            [Resp, RT] = collectResponse(BidWait,0,'56789');
        else
            [Resp, RT] = collectResponse(BidWait,0,'12345'); %Changing the first argument changes the time the bid is on the screen
        end
    DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
    BidOff = Screen(PTBParams.win,'Flip');
    BidOffset = BidOff-StartTime;

    BidDuration = BidOffset-BidOnset;
    logData(PTBParams.datafile,trial,TrialStart,ISI,FoodOn,BidOn,FoodOnset,BidOnset,FoodDuration,BidDuration,FoodPic,FoodNum,Resp,RT);

end

% Wait for 10 seconds and log end time
WaitSecs(10);
EndTime = GetSecs-StartTime;
logData(PTBParams.datafile,1, EndTime);

DrawFormattedText(PTBParams.win,'The task is now complete.','center','center',PTBParams.white); %DCos 2015.5.12, added end screen
Screen(PTBParams.win,'Flip'); 
WaitSecs(2);

%% Close screen
if ~exist('sprout')
    % Housekeeping after the party
    Screen('CloseAll');
    ListenChar(0);
end