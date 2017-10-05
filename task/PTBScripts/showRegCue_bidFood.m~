% bidFood.m
%
% Project: fMRI regulation of goal values
%
% Author: Cendri Hutcherson
% Date: 2.10.09
%
% Description: Display regulation cue, show food picture for 4 seconds, then
% prompt to bid 

WaitTime = 4; % Specifies how long to wait before prompting Pp to rate food

% Show Fixation 
DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
TrialStart = Screen(PTBParams.win,'Flip',jitterstart+jitter(trial));
eval(['PrimePic = Prime' num2str(Primes(trial)) 'Pic;']);
Screen('DrawTexture',PTBParams.win,PrimePic);
CueOn = Screen(PTBParams.win, 'Flip', TrialStart+1);
foodCoords = findPicLoc(size(FoodBmp{Food(trial)}),[.5,.45],PTBParams,'ScreenPct',.55);
keyCoords = findPicLoc(size(BidKeyPic),[.5,.85],PTBParams,'ScreenPct',.35);
FoodScreen = Screen('MakeTexture',PTBParams.win,FoodBmp{Food(trial)});
Screen('DrawTexture',PTBParams.win,FoodScreen,[],foodCoords);
FoodOn = Screen(PTBParams.win,'Flip', TrialStart+3);
% display rating prompt
Screen('DrawTextures',PTBParams.win,[FoodScreen,KeyLegend],[],...
    [foodCoords;keyCoords]');
DrawFormattedText(PTBParams.win,'How much would you pay to eat this food?','center',PTBParams.ctr(2)-.9*PTBParams.ctr(2),PTBParams.white);
BidOn = Screen(PTBParams.win,'Flip',TrialStart+3+WaitTime);
Screen('Close',FoodScreen);
FoodPic = bmps(Food(trial)).name;
FoodNum = Food(trial);
RegCue = Primes(trial);
CueOnset = CueOn-StartTime;
FoodOnset = FoodOn-StartTime;
BidOnset = BidOn-StartTime;