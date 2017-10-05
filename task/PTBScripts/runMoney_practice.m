% Project: fMRI regulation of goal values
%
% Author: Cendri Hutcherson
% Date: 1.19.09
%
% 4/17/15: Nicole commented out lines 62-105, 109-113, 139-163 to remove
% regulation conditions
%
% Description: Runs participants through instructions
clear all;

% Initial setup for PsychToolbox, using InitPTB script
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));
PTBParams = InitPTB(homepath);


%%%%%%%          Preload Practice Pictures          %%%%%%%  
%                                                         %
    %% load food bitmaps into memory
    bmps = dir(fullfile(homepath, 'foodpics', '_practice'));
    
    for x = 1:length(bmps)
        y(x) = ~isempty(regexp(bmps(x).name,'\w*bmp$','match'));
    end
    
    bmps = bmps(y);
    
    for x = 1:length(bmps)
        PracFoodBmp{x} = imread(fullfile(homepath, 'foodpics', '_practice',bmps(x).name));
    end
    FoodBmp = PracFoodBmp;
    %% load Prime pictures into memory
    % select which version of primes to use, counterbalance using subj #
%     if mod(PTBParams.subjid,3)== 0
%         v = 'c';
%     elseif mod(PTBParams.subjid,2) == 0
%         v = 'b';
%     else
%         v = 'a';
%     end
%     
%     Prime0  = imread([homepath 'WhitePrimes/Prime0' v '.bmp'],'BMP');
%     Prime1  = imread([homepath 'WhitePrimes/Prime1' v '.bmp'],'BMP');
%     Prime2  = imread([homepath 'WhitePrimes/Prime2' v '.bmp'],'BMP');
%     RateKeyPic  = imread(fullfile(homepath, 'RateKeys.bmp'),'BMP');
    BidKeyPic = imread(fullfile(homepath, 'BidKeys.bmp'),'BMP');
    
    %% paint bitmaps into offscreen palettes
%     Prime0Pic   = Screen('MakeTexture',PTBParams.win,Prime0);
%     Prime1Pic   = Screen('MakeTexture',PTBParams.win,Prime1);
%     Prime2Pic   = Screen('MakeTexture',PTBParams.win,Prime2);
%     KeyLegend   = Screen('MakeTexture',PTBParams.win,RateKeyPic);
    
    Primes = [0 1 2];
    Food = [1 2 3];
    %% Initialize keys DCos 2015.5.8
    inputDevice = PTBParams.keys.deviceNum;
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%         Run Instruction and Practice        %%%%%%%  
%                                                         %

% for insrx = 1:7
%     showInstruction(insrx,PTBParams,'SlideType','BMP');
% end
%     
% for trial = 1:3
%     
%     showFood;
%     [Resp RT] = collectResponse([],[],'123456');   
%     %logData(trial,FoodPic,FoodNum,Resp,RT);
% 
% end
% 
% showInstruction(8,PTBParams,'SlideType','BMP');
% 
% % Sometimes there is a lag as the computer loads the images.  I've put this
% % screen in here so participants don't get impatient.
% DrawFormattedText(PTBParams.win,'Please wait while the study loads.','center','center',PTBParams.white);
% Screen(PTBParams.win,'Flip');
% %                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%            Preload Food Pictures            %%%%%%%  
% %                                                         %
%     %% load food bitmaps into memory
%     bmps = dir(fullfile(homepath, 'foodpics'));
%     
%     for x = 1:length(bmps)
%         y(x) = ~isempty(regexp(bmps(x).name,'\w*bmp$','match'));
%     end
%     
%     bmps = bmps(y);
%     
%     for x = 1:length(bmps)
%         FoodBmp{x} = imread([homepath 'foodpics/' bmps(x).name]);
%     end
%     Primes = zeros(length(FoodBmp));
%     Food = randperm(length(FoodBmp));
% %                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%         Run Preliminary Liking Trials       %%%%%%%  
% %                                                         %
%     for trial = 1:150 %num trials
% 
%         showFood;
%         [Resp RT] = collectResponse([],[],'123456');   
%         logData(PTBParams.datafile,trial,FoodPic,FoodNum,Resp,RT);
% 
%     end

%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%         Run Instruction for Bid and Reg     %%%%%%%  
%                                                         %
    FoodBmp = PracFoodBmp;
    KeyLegend = Screen('MakeTexture',PTBParams.win,BidKeyPic);
    
    if PTBParams.inMRI == 1
        DrawFormattedText(PTBParams.win,'Calibrating scanner.\n\n Please hold VERY still.','center','center',PTBParams.white);
    else 
        DrawFormattedText(PTBParams.win,'The task is about to begin.\n\n Get ready!','center','center',PTBParams.white);
    end
    Screen(PTBParams.win,'Flip');

    %StartTime = GetSecs(); %DCos 2015.5.8, commented out to run in the
    %mock with scantrig
    scantrig; 
    logData(PTBParams.datafile,1,StartTime);
    
    for insrx = 1 %DCos, 2015.5.8, replace 9:19
        showInstruction(1,PTBParams,'SlideType','BMP');
    end
    
    Jitter = jitter(2,3,1); 
    bidTest

    showInstruction(6,PTBParams,'SlideType','BMP')
    Food = [2 3 1];
    for trial = 1:3 %num trials

        bidFood;
        if PTBParams.inMRI == 1
            [Resp RT] = collectResponse(4,0,'56789'); %DCos 2015.4.24, replaced collectResponse(2,0,'56789')
        else
            [Resp RT] = collectResponse(4,0,'12345');
        end
        logData(PTBParams.datafile,trial,FoodPic,FoodNum,Resp,RT);

    end

    DrawFormattedText(PTBParams.win,'The task is now complete.','center','center',PTBParams.white); %DCos 2015.5.12, added end screen
    Screen(PTBParams.win,'Flip');
    WaitSecs(2);

% for insrx = 25:26
%     showInstruction(insrx,PTBParams,'SlideType','BMP');
% end
% 
% for m = [1,2,0]
%     showPrimeInstruction1
% end
% 
% for insrx = 30:31
%     showInstruction(insrx,PTBParams,'SlideType','BMP');
% end
%     
% showPrimeInstruction2
% 
% showInstruction(34,PTBParams,'SlideType','BMP');
% 
% Primes = [2 1 0];
% Food = [3 2 1];
% for trial = 1:3 %num trials
%     jitterstart = GetSecs;
%     jitter(trial) = 0;
%     showRegCue_bidFood
%     [Resp RT] = collectResponse(2,0,'123456');   
%     %logData(trial,FoodPic,FoodNum,RegCue,Resp,RT);
% end
    
if ~exist('sprout')
    %% Housekeeping after the party
    Screen('CloseAll');
    ListenChar(0);
end




