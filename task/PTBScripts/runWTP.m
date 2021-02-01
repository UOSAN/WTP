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
clear PsychHID;
clear all;

pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));
[PTBParams, runNum, study] = InitPTB(homepath);
homepath=PTBParams.homepath;

%% Set dropbox path for copying
dropboxDir = '~/Dropbox (University of Oregon)/UO-SAN Lab/Berkman Lab/Devaluation/Tasks/WTP/output';

%% Load trial and subject condition info
% Load trial condition order info (design created using the CAN lab GA)
% https://github.com/UOSAN/CanLabCore_GA/tree/master/SAN_GAs/DEV

if str2num(PTBParams.ssnid) < 3
    TrialOrder = {'unhealthy_liked', 'healthy_liked', 'healthy_liked', ...
        'unhealthy_disliked', 'unhealthy_liked', 'healthy_disliked', ...
        'unhealthy_liked', 'unhealthy_disliked', 'healthy_liked', ...
        'healthy_disliked', 'unhealthy_disliked', 'unhealthy_disliked', ...
        'healthy_disliked', 'healthy_disliked', 'healthy_liked', 'unhealthy_liked'};
else
    TrialOrder = {'unhealthy_liked', 'healthy_liked', 'healthy_liked', ...
        'unhealthy_disliked', 'unhealthy_liked', 'healthy_disliked', ...
        'unhealthy_liked', 'unhealthy_disliked', 'healthy_liked', ...
        'healthy_disliked', 'unhealthy_disliked', 'unhealthy_disliked', ...
        'healthy_disliked', 'healthy_disliked', 'healthy_liked', 'unhealthy_liked', ...
        'unhealthy_liked', 'healthy_liked', 'healthy_liked', ...
        'unhealthy_disliked', 'unhealthy_liked', 'healthy_disliked', ...
        'unhealthy_liked', 'unhealthy_disliked', 'healthy_liked', ...
        'healthy_disliked', 'unhealthy_disliked', 'unhealthy_disliked', ...
        'healthy_disliked', 'healthy_disliked', 'healthy_liked', 'unhealthy_liked'};
end

% Load subject condition info
subinput = sprintf('%sinput/%s%s_%s_condinfo.mat',homepath,study,PTBParams.subjid, PTBParams.ssnid);

if exist(subinput)
    load(subinput);
else
    error('Subject input file (%s) does not exist. \nPlease ensure you have run runGetStimWTP.m',subinput);
end

% Define image order based on trial and condition info
bmps = cell(1,length(TrialOrder));
conds = unique(TrialOrder);
for i = 1:length(conds)
    cond = conds{i};
    idxs = find(strcmp(TrialOrder,cond));
    a = 1;
    for j = 1:length(idxs)
        idx = idxs(j);
        bmps{idx} = eval(sprintf('run%d_%s{a,1}',PTBParams.(char(runNum)).runid,cond));
        a = a+1;
    end
end

%% Preload Stimulus Pictures 
% Load food bitmaps into memory
for x = 1:length(bmps)
    FoodBmp{x} = imread(fullfile(sprintf('%sfoodpics/run%d/%s', homepath, PTBParams.(char(runNum)).runid, bmps{x})),'bmp');
end

% Specify food order (sequential because order is defined in previous chunk)
Food = 1:length(TrialOrder);

%% Load bid key bitmap into memory
BidKeyPic = imread(fullfile(homepath, 'BidKeys.bmp'),'BMP');

%% Paint bid key bitmap into offscreen palettes
KeyLegend = Screen('MakeTexture',PTBParams.win,BidKeyPic);

%% Load jitter
if str2num(PTBParams.ssnid) < 3
    load(fullfile(homepath,'input','jitter.mat'))
else
    Jitter = ones(length(TrialOrder),1);
end

% Check to make sure the number of trials and jitter is the same
if length(Jitter) < length(TrialOrder)
    error('There are not enough jitter trials allocated. \nThere are %d jitters and %d trials. \nCheck jitter file %s and consider rerunning runJitter.m', ...
        length(Jitter), length(TrialOrder), fullfile(homepath,'input','jitter.mat'))
end

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
% Wait for   a 'spacebar' to start the behavioral version, and an ' for the scanner version
scantrig;

datafile = PTBParams.datafile;
logData(datafile,runNum,1,StartTime,Jitter);

% Run task
for trial = 1:length(FoodBmp) %num trials
    bidFood
    BidWait = 2.5;
        if PTBParams.inMRI == 1 %In the scanner use 5678, if outside use 1234
            [Resp, RT] = collectResponse(BidWait,0,'5678');
        else
            [Resp, RT] = collectResponse(BidWait,0,'1234'); %Changing the first argument changes the time the bid is on the screen
        end
    DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
    BidOff = Screen(PTBParams.win,'Flip');
    BidOffset = BidOff-StartTime;

    BidDuration = BidOffset-BidOnset;
    logData(datafile,runNum,trial,TrialStart,ISI,FoodOn,BidOn,FoodOnset,...
            BidOnset,FoodDuration,BidDuration,FoodPic,FoodNum,Cond,HealthCond,LikingCond,LikingRating,Resp,RT);
end

% Wait for 6 seconds and log end time
WaitSecs(6);
EndTime = GetSecs-StartTime;
logData(datafile,runNum,1, EndTime);

DrawFormattedText(PTBParams.win,'The task is now complete.','center','center',PTBParams.white);
Screen(PTBParams.win,'Flip'); 
WaitSecs(4);

%% Close screen
if ~exist('sprout')
    % Housekeeping after the party
    Screen('CloseAll');
    ListenChar(0);
end

%% Copy file to dropbox
subCode = sprintf('DEV%s',PTBParams.subjid);
subDir = fullfile(dropboxDir,subCode);
if ~exist(subDir)
    copyfile(sprintf('SubjectData/%s',subCode), subDir);
    disp(sprintf('Output file copied to %s',subDir));
else
    copyfile(sprintf('SubjectData/%s/',subCode), subDir);
    disp(sprintf('Output file copied to %s',subDir));
end