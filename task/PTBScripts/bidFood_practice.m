%% bidFood.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Cendri Hutcherson
% Modified by: Dani Cosme
% Last Modified: 10-06-2017
%
% Description: Show food picture for variable number of seconds, then
% prompt with bid 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run script for each trial
% Specify food image and fixation presentation lengths
WaitTime = 4; %Specifies how long to wait before bid keys appear
ISI = Jitter(trial)+3; %Added ISI so that it can be logged, DEC 15.4.27

% Display fixation 
DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
TrialStart = Screen(PTBParams.win,'Flip');

% Display food
foodCoords = findPicLoc(size(FoodBmp{Food(trial)}),[.5,.45],PTBParams,'ScreenPct',.55);
keyCoords = findPicLoc(size(BidKeyPic),[.5,.85],PTBParams,'ScreenPct',.25);
FoodScreen = Screen('MakeTexture',PTBParams.win,FoodBmp{Food(trial)});
Screen('DrawTexture',PTBParams.win,FoodScreen,[],foodCoords);
FoodOn = Screen(PTBParams.win,'Flip', TrialStart+ISI); %ISI = 3.5, added jitter here instead of using the jitterfix function, DEC 15.4.27, TrialStart+1.5

% Display rating prompt after time specified in WaitTime
Screen('DrawTextures',PTBParams.win,[FoodScreen,KeyLegend],[],...
    [foodCoords;keyCoords]');
DrawFormattedText(PTBParams.win,'How much would you pay to eat this food?','center',PTBParams.ctr(2)-.9*PTBParams.ctr(2),PTBParams.white);
BidOn = Screen(PTBParams.win,'Flip',FoodOn+WaitTime);
Screen('Close',FoodScreen);

