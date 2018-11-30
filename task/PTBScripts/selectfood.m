function selectfood(foodpics)
% This script is used to randomly select a trial from the participant's 
% responses and delivers the bid information for that trial
% 
% Author: Cendri Hutcherson
% Modified by: Dani Cosme
% Last Modified: 10-30-2017

%% Add path
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));

%% Get subject and run info
study = 'DEV'; %removed user input for convenience 
subjid = input('Subject number (3 digits):  ', 's');
ssnid = input('Session number (1-4):  ', 's');
inMRI = input('MRI session? 0 = no, 1 = yes: ');

%% Initialize variables
FoodstoSelect = [];
Bids = [];
HealthCond = [];

%% Load data and PTB files
dropboxDir = '~/Dropbox (PfeiBer Lab)/Devaluation/Tasks/WTP/output';
datapath = fullfile(dropboxDir, [study subjid], [study,'.',subjid,'.',ssnid,'.mat']);
ptbpath = fullfile(dropboxDir, [study subjid], ['PTBParams.',subjid,'.',ssnid,'.mat']);

if exist(datapath)
    load(datapath);
    load(ptbpath);
else
    error('Subject input file (%s) does not exist. \nCheck subject ID and session number.',datapath);
end
    
nRuns = length(find(~cellfun(@isempty,regexp(fieldnames(Data),'run[1-9]{1}'))));
for i = 1:nRuns
    runName = sprintf('run%d',i);
    FoodstoSelect = [FoodstoSelect, Data.(char(runName)).FoodPic];
    Bids = [Bids, Data.(char(runName)).Resp];
    HealthCond = [HealthCond, Data.(char(runName)).HealthCond];
end

%% Choose a random trial
choosefood = randperm(length(FoodstoSelect));

iter = 1;
foodchosen = 0;

while foodchosen == 0 
    
    selected = FoodstoSelect(choosefood(iter));
    x = ismember(foodpics, selected{1});

    if sum(x) == 0
        %disp('No food matches found within subset. Continuing to search.')
        iter = iter+1;
    else
        disp('Food found.')
        foodchosen = 1;
        bid = Bids(choosefood(iter));
        trial = num2str(choosefood(iter));
        foodName = selected{1};
    end
end

%% Get bid info and convert it to dollar amount
if bid{1} == 'NULL'
    bid = 0;
else
    if inMRI == 0
        bid = str2num(bid{1});
        bid = (bid-1)/2;
    else
        bid = str2num(bid{1});
        bid = (bid-5)/2;
    end
end

%% Pick random bid value
bidsPossible = [0 .5 1 1.5];
if inMRI == 1
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

%% Display information in the command window
clc
disp('---------------------');
disp('Auction results');
disp('---------------------');
disp(['Food selected: ',char(foodName)]);
disp(['Participant bid: ',cur2str(bid)]);
disp(['Random bid: ',cur2str(bidRand)]);
disp(' ');
disp(match);
disp(['Money left: ',cur2str(1.5-bid)]);
