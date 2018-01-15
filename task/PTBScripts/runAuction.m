%% Run Food Auction script %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script should be used to define which foods are available for the
% food selection auction. Just add these foods below and they will be
% passed to the selectfood function (selectfood.m) which will select a
% random trial, a random bid, and compare this bid to the participant's
% real bid.
%
% Inputs: 
% -foodpics
%
% Outputs:
% -Food selected
% -Participant bid value
% -Random bid value
% -Match info
% -Money left over ($1.50-participant bid)
%
% Author: Dani Cosme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define available foods
% These are the image names and should be inputted as string.

foodpics = {...
'chilifritos.bmp'; ...
'cornnuts.bmp'; ...
'peachrings.bmp'; ...
'Reeses.bmp'; ...
'choccookie.bmp'; ...
'Blueberries.bmp'; ...
'FruitLeather3.bmp'; ...
'Pistachios2.bmp'; ...
'Yogurt.bmp'; ...
'FruitLeather.bmp'; ...
'PotatoChips.bmp'};

%% Run food auction
selectfood(foodpics);