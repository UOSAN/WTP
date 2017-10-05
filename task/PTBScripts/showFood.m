% showFood.m
%
% Project: fMRI regulation of goal values
%
% Author: Cendri Hutcherson
% Date: 1.19.09
%
% Description: Show food picture for variable number of seconds, then
% prompt with rating

WaitTime = 1; % Specifies how long to wait before prompting Pp to rate food

% Show Fixation 
DrawFormattedText(PTBParams.win,'+','center','center',PTBParams.white);
TrialStart = Screen(PTBParams.win,'Flip');
%eval(['PrimePic = Prime' num2str(Primes(trial)) 'Pic']);
%Screen('DrawTexture',w,PrimePic);
foodCoords = findPicLoc(size(FoodBmp{Food(trial)}),[.5,.45],PTBParams,'ScreenPct',.55);
FoodScreen = Screen('MakeTexture',PTBParams.win,FoodBmp{Food(trial)});
%PrimeOn = Screen(w,'Flip',TrialStart+1.5);
Screen('DrawTexture',PTBParams.win,FoodScreen,[],foodCoords);
FoodOn = Screen(PTBParams.win,'Flip', TrialStart+1.5);
% display rating prompt

keyCoords = findPicLoc(size(RateKeyPic),[.5,.85],PTBParams,'ScreenPct',.35);
Screen('DrawTextures',PTBParams.win,[FoodScreen,KeyLegend],[],...
    [foodCoords;keyCoords]');
DrawFormattedText(PTBParams.win,'How much would you like to eat this food?','center',PTBParams.ctr(2)-.9*PTBParams.ctr(2),PTBParams.white);
Screen(PTBParams.win,'Flip',FoodOn + WaitTime);
Screen('Close',FoodScreen);
Prime = Primes(trial);
FoodPic = bmps(Food(trial)).name;
FoodNum = Food(trial);