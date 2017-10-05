% Project: fMRI regulation of goal values
%
% Author: Cendri Hutcherson
% Date: 2.10.09
%
% Description: Runs participants through scan 1 of regulation and bidding
% trials.

% if script is called from main, do NOT run initial setup

clear all;

% Initial setup for PsychToolbox, using InitPTB script
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));
PTBParams = InitPTB(homepath);

%%%%%%%          Preload Stimulus Pictures          %%%%%%%  
%                                                         %
        %% load food bitmaps into memory
    bmps = dir(fullfile(homepath, 'foodpics'));
    
    for x = 1:length(bmps)
        y(x) = ~isempty(regexp(bmps(x).name,'\w*bmp$','match'));
    end
    
    bmps = bmps(y);
    
    for x = 1:length(bmps)
        FoodBmp{x} = imread([homepath 'foodpics/' bmps(x).name],'bmp');
    end
 
    Food = randperm(length(FoodBmp));
    
    %% load Prime pictures into memory
    % select which version of primes to use, counterbalance using subj #
    if mod(PTBParams.subjid,3)== 0
        v = 'c';
    elseif mod(PTBParams.subjid,2) == 0
        v = 'b';
    else
        v = 'a';
    end
    
%     Prime0  = imread([homepath 'WhitePrimes/Prime0' v '.bmp'],'BMP');
%     Prime1  = imread([homepath 'WhitePrimes/Prime1' v '.bmp'],'BMP');
%     Prime2  = imread([homepath 'WhitePrimes/Prime2' v '.bmp'],'BMP');
%     RateKeyPic  = imread(fullfile(homepath, 'RateKeys.bmp'),'BMP');
    BidKeyPic = imread(fullfile(homepath, 'BidKeys.bmp'),'BMP');
    
    %% paint bitmaps into offscreen palettes
%     Prime0Pic   = Screen('MakeTexture',PTBParams.win,Prime0);
%     Prime1Pic   = Screen('MakeTexture',PTBParams.win,Prime1);
%     Prime2Pic   = Screen('MakeTexture',PTBParams.win,Prime2);
    KeyLegend   = Screen('MakeTexture',PTBParams.win,BidKeyPic);
    
    %% Setup jitter
    Jitter = jitter(2,60,1); 
    %% Initialize keys DCos 2015.5.8
    inputDevice = PTBParams.keys.deviceNum;
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Sometimes there is a lag as the computer loads the images.  I've put this
% screen in here so participants don't get impatient.
if PTBParams.inMRI == 1
    DrawFormattedText(PTBParams.win,'Calibrating scanner.\n\n Please hold VERY still.','center','center',PTBParams.white);
else 
    DrawFormattedText(PTBParams.win,'The task is about to begin.\n\n Get ready!','center','center',PTBParams.white);
end
Screen(PTBParams.win,'Flip');
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wait for the ' key (scan trigger) before continuing
scantrig; %This function waits for a 'spacebar' to start the behavioral version, and an ' for the scanner version DEC 15.4.22
logData(PTBParams.datafile,1,StartTime,Jitter);

%%%%%%%              Run Regulation Trials          %%%%%%%  
%                                                         %


    for trial = 1:60 %num trials
        bidFood
            if PTBParams.inMRI == 1 %In the scanner use 56789, if outside use 123456, DEC 15.4.22
                [Resp, RT] = collectResponse(4,0,'56789'); %DEC 15.4.22, '123456'
            else
                [Resp, RT] = collectResponse(4,0,'12345'); %Changing the first argument changes the time the bid is on the screen
            end
        DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
        Screen(PTBParams.win,'Flip');
        
        logData(PTBParams.datafile,trial,TrialStart,ISI,FoodOn,FoodOnset,BidOnset,FoodPic,FoodNum,Resp,RT);

    end

    WaitSecs(10);
    EndTime = GetSecs-StartTime;
    logData(PTBParams.datafile,1, EndTime);

DrawFormattedText(PTBParams.win,'The task is now complete.','center','center',PTBParams.white); %DCos 2015.5.12, added end screen
Screen(PTBParams.win,'Flip'); 
WaitSecs(2);

%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
if ~exist('sprout')
    %% Housekeeping after the party
    Screen('CloseAll');
    ListenChar(0);
end




