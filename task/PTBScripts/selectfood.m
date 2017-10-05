function selectfood(foodpics)
%   This script is used to randomly select a trial from the participant's 
%   responses and delivers the bid information for that trial
% 
%   Modified by DCos 2015.4.29
%
%%%

%% Add path
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));

%% Get subject and run info
subjid = input('Subject number:  ', 's');
ssnid = input('Session number:  ', 's');

%% Initialize variables
FoodstoSelect = [];
Bids = [];

%% Load data and PTB files
load(fullfile([homepath,'/SubjectData/', num2str(subjid), '/PTBParams.', num2str(subjid), '.', num2str(ssnid), '.mat']));
load(fullfile([homepath,'/SubjectData/', num2str(subjid), '/Data.', num2str(subjid), '.', num2str(ssnid), '.mat']));
FoodstoSelect = [FoodstoSelect, Data.FoodPic];
Bids = [Bids, Data.Resp];

%% Choose a random trial
choosefood = randperm(length(FoodstoSelect));

iter = 1;
foodchosen = 0;

while foodchosen == 0 
    
    x = ismember(foodpics, FoodstoSelect(choosefood(iter)));

    if sum(x) == 0
        %disp('No food matches found within subset. Continuing to search.')
        iter = iter+1;
    else
        disp('Food match found.')
        food = imread([homepath 'foodpics/' foodpics{find(x==1)}], 'BMP');
        foodchosen = 1;
        bid = Bids(choosefood(iter));
        trial = num2str(choosefood(iter));
        foodName = FoodstoSelect(choosefood(iter));
    end
end

%% Get bid info and convert it to dollar amount
if bid{1} == 'NULL'
    bid = 0;
else
    bid = str2num(bid{1});
    bid = (bid-1)/2;
end

%% Pick random bid value
bidsPossible = [0 .5 1 1.5 2];
if ssnid == 2
    bidRand = 0; %Rigged auction for after scanner 
else
    bidRand = randsample(bidsPossible,1); %Normal auction for behavioral session
end

%% Check if bid is greater than or equal to the randomly selcted bid
if bid >= bidRand
    match = 'Match. You will recieve this snack.';
else
    match = 'No match. You will not recieve this snack.';
end

    
%% Initialize Screen
    AssertOpenGL;
    ListenChar(2); % don't print keypresses to screen
%   Screen('Preference', 'SkipSyncTests', 1); % use if VBL fails
    Screen('Preference', 'VisualDebugLevel',3);

    HideCursor;
    screenNum = 0;
    
    if str2double(subjid) > 900
        [w, rect] = Screen('OpenWindow',screenNum, [], [0 0 800 600]); %partial screen mode, for debugging
    else
        [w, rect] = Screen('OpenWindow',screenNum);
    end
    
    ctr = [rect(3)/2, rect(4)/2]; 
    white=WhiteIndex(w);
    black=BlackIndex(w);
    gray = (WhiteIndex(w) + BlackIndex(w))/2;
    ifi = Screen('GetFlipInterval', w);
    
    % setup screen
    Screen(w,'TextSize',round(.1*ctr(2)));
    Screen('TextFont',w,'Helvetica');
    Screen('FillRect',w,black);
    
%% Draw text
DrawFormattedText(PTBParams.win,['Trial selected: ' trial],'center',PTBParams.ctr(2)-.5*PTBParams.ctr(2),PTBParams.white);
Screen(w,'Flip',[],1);
DrawFormattedText(PTBParams.win,'Food on trial ','center',ctr(2)-.3*PTBParams.ctr(2),PTBParams.white);
WaitSecs(1.5);
Screen(w,'Flip',[],1);
FoodPic=Screen('MakeTexture',PTBParams.win,food);
Screen('DrawTexture',PTBParams.win,FoodPic);
WaitSecs(1.5);
Screen(w,'Flip',[],1);
DrawFormattedText(PTBParams.win,['Random bid selected: ',cur2str(bidRand)],'center',ctr(2)-.3*PTBParams.ctr(2),PTBParams.white);
WaitSecs(1.5);
Screen(w,'Flip',[],1);
DrawFormattedText(PTBParams.win,['Your bid on trial: ',cur2str(bid)],'center',PTBParams.ctr(2)-.3*PTBParams.ctr(2),PTBParams.white);
WaitSecs(2);
Screen(w,'Flip');
DrawFormattedText(PTBParams.win,match,'center',PTBParams.white);
WaitSecs(2);
Screen(w,'Flip');

while ~GetChar
end

%% Housekeeping after the party

 Screen('CloseAll');
 ListenChar(0);
 
 %% Display information in the command window
disp('---------------------');
disp('Auction results');
disp('---------------------');
disp(['Food selected: ',char(foodName)]);
disp(['Participant bid: ',cur2str(bid)]);
disp(['Random bid: ',cur2str(bidRand)]);
disp(match);
disp(['Money left: ',cur2str(2-bid)]);


    
    