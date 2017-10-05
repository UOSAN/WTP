% bidFood.m
%
% Project: fMRI regulation of goal values
%
% Author: Cendri Hutcherson
% Date: 2.3.09
%
% Description: Show food picture for variable number of seconds, then
% prompt with bid 

WaitTime = 4; % Specifies how long to wait before prompting Pp to rate food
ISI = Jitter(trial)+1.5; %Added ISI so that it can be logged, DEC 15.4.27

% Show Fixation 
DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
TrialStart = Screen(PTBParams.win,'Flip');
foodCoords = findPicLoc(size(FoodBmp{Food(trial)}),[.5,.45],PTBParams,'ScreenPct',.55);
keyCoords = findPicLoc(size(BidKeyPic),[.5,.85],PTBParams,'ScreenPct',.35);
FoodScreen = Screen('MakeTexture',PTBParams.win,FoodBmp{Food(trial)});
Screen('DrawTexture',PTBParams.win,FoodScreen,[],foodCoords);
FoodOn = Screen(PTBParams.win,'Flip', TrialStart+ISI); %ISI = 3.5, added jitter here instead of using the jitterfix function, DEC 15.4.27, TrialStart+1.5
% display rating prompt
Screen('DrawTextures',PTBParams.win,[FoodScreen,KeyLegend],[],...
    [foodCoords;keyCoords]');
DrawFormattedText(PTBParams.win,'How much would you pay to eat this food?','center',PTBParams.ctr(2)-.9*PTBParams.ctr(2),PTBParams.white);
BidOn = Screen(PTBParams.win,'Flip',FoodOn+WaitTime);
Screen('Close',FoodScreen);
FoodPic = bmps(Food(trial)).name;
FoodNum = Food(trial);
FoodOnset = FoodOn-StartTime;
BidOnset = BidOn-StartTime;
