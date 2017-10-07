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
    
    %% load Prime pictures into memory
    % select which version of primes to use, counterbalance using subj #
    if mod(PTBParams.subjid,3)== 0
        v = 'c';
    elseif mod(PTBParams.subjid,2) == 0
        v = 'b';
    else
        v = 'a';
    end
    
    Prime0  = imread([homepath 'WhitePrimes/Prime0' v '.bmp'],'BMP');
    Prime1  = imread([homepath 'WhitePrimes/Prime1' v '.bmp'],'BMP');
    Prime2  = imread([homepath 'WhitePrimes/Prime2' v '.bmp'],'BMP');
    RateKeyPic  = imread(fullfile(homepath, 'RateKeys.bmp'),'BMP');
    BidKeyPic = imread(fullfile(homepath, 'BidKeys.bmp'),'BMP');
    
    %% paint bitmaps into offscreen palettes
    Prime0Pic   = Screen('MakeTexture',PTBParams.win,Prime0);
    Prime1Pic   = Screen('MakeTexture',PTBParams.win,Prime1);
    Prime2Pic   = Screen('MakeTexture',PTBParams.win,Prime2);
    KeyLegend   = Screen('MakeTexture',PTBParams.win,BidKeyPic);
    
    load(fullfile(homepath, 'SubjectData',num2str(PTBParams.subjid), 'TrialOrder.mat'));
    Food = Food(101:150);
    Primes = Primes(101:150);
    
    jitter                  = repmat([0; .5; 1; 1.5; 2],10,1);
    jitter                  = jitter(randperm(50));
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Sometimes there is a lag as the computer loads the images.  I've put this
% screen in here so participants don't get impatient.
DrawFormattedText(PTBParams.win,'Prepare to begin...','center','center',PTBParams.white);
Screen(PTBParams.win,'Flip');
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wait for the 5 key (scan trigger) before continuing
scantrig

logData(PTBParams.datafile,1,StartTime,jitter)

%%%%%%%              Run Regulation Trials          %%%%%%%  
%                                                         %


    for trial = 1:50 %num trials
        jitterfix
        showRegCue_bidFood
        [Resp RT] = collectResponse(2,0,'234987');
        
        DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
        Screen(PTBParams.win,'Flip');
        
        logData(PTBParams.datafile,trial,CueOnset,FoodOnset,BidOnset,FoodPic,FoodNum,RegCue,Resp,RT);

    end

    WaitSecs(10);
    EndTime = GetSecs-StartTime;
    logData(PTBParams.datafile,1, EndTime);

%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
if ~exist('sprout')
    %% Housekeeping after the party
    Screen('CloseAll');
    ListenChar(0);
end




