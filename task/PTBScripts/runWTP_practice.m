%% Willingness to Pay task practice %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Cendri Hutcherson
% Modified by: Dani Cosme
% Last Modified: 10-06-2017
%
% Description: This script runs the practice task. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initial setup for PsychToolbox, using InitPTB.m
clear PsychHID;
clear all;

pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));
[PTBParams] = InitPTB_practice(homepath);

%% Preload Stimulus Pictures 
% Load food bitmaps into memory
bmps = dir(fullfile(homepath, 'foodpics', '_practice'));

for x = 1:length(bmps)
    y(x) = ~isempty(regexp(bmps(x).name,'\w*bmp$','match'));
end

bmps = bmps(y);

for x = 1:length(bmps)
    PracFoodBmp{x} = imread(fullfile(homepath, 'foodpics', '_practice',bmps(x).name));
end
FoodBmp = PracFoodBmp; 

%% Load bid key bitmap into memory
BidKeyPic = imread(fullfile(homepath, 'BidKeys.bmp'),'BMP');

%% Initialize keys 
inputDevice = PTBParams.keys.deviceNum;

%% Run instructions
FoodBmp = PracFoodBmp;
KeyLegend = Screen('MakeTexture',PTBParams.win,BidKeyPic);

if PTBParams.inMRI == 1
    DrawFormattedText(PTBParams.win,'Calibrating scanner.\n\n Please hold VERY still.','center','center',PTBParams.white);
else 
    DrawFormattedText(PTBParams.win,'The task is about to begin.\n\n Get ready!','center','center',PTBParams.white);
end
Screen(PTBParams.win,'Flip');

%% Run task and log data
% Wait for the trigger before continuing
% Wait for a 'spacebar' to start the behavioral version, and an ' for the scanner version
scantrig; 
StartTime = GetSecs(); %May need to be commented out to run in the mock with scantrig

for insrx = 1
    showInstruction(1,PTBParams,'SlideType','BMP');
end

Jitter = jitter(1,3,1); 
bidTest

showInstruction(6,PTBParams,'SlideType','BMP')
Food = [2 3 1];

% Run task
for trial = 1:3 %num trials
    bidFood_practice;
    BidWait = 2.5;
        if PTBParams.inMRI == 1 %In the scanner use 5678, if outside use 1234
            [Resp, RT] = collectResponse(BidWait,0,'5678');
        else
            [Resp, RT] = collectResponse(BidWait,0,'1234'); %Changing the first argument changes the time the bid is on the screen
        end
    DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
    BidOff = Screen(PTBParams.win,'Flip');
end

% Wait for 2 seconds and close
DrawFormattedText(PTBParams.win,'The task is now complete.','center','center',PTBParams.white); %DCos 2015.5.12, added end screen
Screen(PTBParams.win,'Flip');
WaitSecs(4);

%% Close screen
if ~exist('sprout')
    %% Housekeeping after the party
    Screen('CloseAll');
    ListenChar(0);
end