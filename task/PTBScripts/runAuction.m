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
'Almonds.bmp', ...
'Cashews.bmp', ...
'ClifBar1.bmp', ...
'ClifBar2.bmp', ...
'Fruit Leather.bmp', ...
'Peanuts.bmp', ...
'BarbequeChips.bmp', ...
'Cheetos.bmp', ...
'CoolRanchDoritos.bmp', ...
'Doritos.bmp', ...
'Fritos.bmp', ...
'Oreos.bmp', ...
'PotatoChips.bmp', ...
'RiceKrispiesTreat.bmp', ...
'SourCreamChips.bmp'};

%% Run food auction
selectfood(foodpics);