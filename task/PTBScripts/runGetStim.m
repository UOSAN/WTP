%% runImages.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script selects food images based on their ratings,
% randomizes them, separates them into runs, and adds the images to the run
% directories in task/foodpics/run[X] 
% 
% Inputs: Ratings .csv file in WTP/input with the following name:
%   [study][subject ID]_ratings.csv (e.g. DEV999_ratings.csv)
% 
% Outputs: Trial condition info saved as a .mat file in WTP/input. This
%   file is used when running the task via runWTP.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housecleaning before the guests arrive
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));

cd(homepath);
clear all; close all; Screen('CloseAll'); 
homepath = [pwd '/'];

%% Get study, subject id, and number of runs from user
study = input('Study name:  ', 's');
subjid = input('Subject number:  ', 's');
nruns = input('Number of runs (DEV = 4):  ');
ntrials = input('Total number of trials per condition (DEV = 16):  ');

%% Load image info
% Define subject input file
subinput = sprintf('%sinput/%s%s_ratings.csv',homepath,study,subjid);

% Load image rating info
if exist(subinput)
    fid=fopen(subinput);
    imageinfo = textscan(fid, '%n%n%s', 'Delimiter', ',', 'treatAsEmpty','NULL', 'EmptyValue', NaN);
    fclose(fid);
else
    error(sprintf('Subject input file (%s) does not exist',subinput));
end

%% Check if number of stimuli set is divisible by the number of runs
if mod(ntrials,nruns) ~= 0
    error('The number of trials is not divisible by the number of runs. Check the inputs.')
end

%% Check if there are enough stimuli for the number of trials specified
if length(imageinfo{1,1}) < ntrials*nruns
    error('The number of stimuli available is less than the number of trials specified');
end

%% Create run directories and remove old images
% Create directories if they do not exist
for i = 1:nruns
    rundir = fullfile(sprintf('%sfoodpics/run%d', homepath, i));
    if ~exist(rundir)
        disp(sprintf('Run directory %d did not exist. Creating it now.',i))
        mkdir(rundir);
    end 
end

% Remove current images from run directories
disp('Removing files from run directories')
for i = 1:nruns
    rundir = dir(fullfile(sprintf('%sfoodpics/run%d', homepath, i)));
    if numel(rundir) > 2
        delete(sprintf('%sfoodpics/run%d/*.bmp', homepath, i));
    end
end

%% Sort healthy foods into runs
% Select healthy images
healthyidx = find(strcmp(imageinfo{1,2},'healthy'));
healthyimages = imageinfo{1,3}(healthyidx);
healthyratings = imageinfo{1,1}(healthyidx);

% Sort images by rating (ascending 1-4)
[sortedvals, sortidx] = sort(healthyratings);

% Check if there are enough trials with ratings 1-4 and exclude 0s
sumtrials = sum(sortedvals > 0);
deficit = 2*ntrials - sumtrials;

if deficit > 0
    warning(sprintf('Too few images with ratings > 0. Including %d trials rated 0.', deficit));
    sortedvals_g0 = sortedvals(end-(2*ntrials-1):end);
    sortidx_g0 = sortidx(end-(2*ntrials-1):end);
else
    sortedvals_g0 = sortedvals(sortedvals > 0);
    sortidx_g0 = sortidx(sortedvals > 0);
end

% Shuffle within rating category
vals = unique(sortedvals_g0);
randidx = [];

for i = 1:length(vals)
    val = vals(i);
    validx = sortidx_g0(find(sortedvals_g0 == val));
    temp = validx(randperm(length(validx)));
    randidx = vertcat(randidx,temp);
end

% Select first and last n trials 
healthyliked = healthyimages(randidx(end-(ntrials-1):end));
healthydisliked = healthyimages(randidx(1:ntrials));

% Randomize images
healthyliked_rand = healthyliked(randperm(length(healthyliked)));
healthydisliked_rand = healthydisliked(randperm(length(healthydisliked)));

% Liked foods: Specify runs and first and last images to select from top images
n = length(healthyliked_rand)/nruns;
first = 1;
last = n; 

    % Create run variables with image positions for healthy liked foods
    disp('Adding healthy liked foods to run directories')
    for i = 1:nruns
      % specify image positions and images
      evalc(sprintf('run%d_healthy_liked = healthyliked_rand(first:last)', i));

      % move images
      for j = 1:length(eval(sprintf('run%d_healthy_liked',i)))
          runimg = eval(sprintf('run%d_healthy_liked{j}', i));
          copyfile(sprintf('%sfoodpics/healthy/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
      end

      % update iterators
      first = first + n;
      last = last + n;
    end

% Disiked foods: Specify runs and first and last images to select from top images
n = length(healthydisliked_rand)/nruns;
first = 1;
last = n; 

    % Create run variables with image positions for healthy liked foods
    disp('Adding healthy disliked foods to run directories')
    for i = 1:nruns
      % specify image positions and images
      evalc(sprintf('run%d_healthy_disliked = healthydisliked_rand(first:last)', i));

      % move images
      for j = 1:length(eval(sprintf('run%d_healthy_disliked',i)))
          runimg = eval(sprintf('run%d_healthy_disliked{j}', i));
          copyfile(sprintf('%sfoodpics/healthy/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
      end

      % update iterators
      first = first + n;
      last = last + n;
    end

% Check images to ensure no image is selected twice
runcheck = who('run*_healthy*');
b = [];
for i = 1:length(runcheck)
    a = eval(runcheck{i});
    b = vertcat(b,a);
end
disp(sort(b));

%% Sort unhealthy foods into runs
% Select unhealthy images
unhealthyidx = find(strcmp(imageinfo{1,2},'unhealthy'));
unhealthyimages = imageinfo{1,3}(unhealthyidx);
unhealthyratings = imageinfo{1,1}(unhealthyidx);

% Sort images by rating (ascending 1-4)
[sortedvals, sortidx] = sort(unhealthyratings);

% Check if there are enough trials with ratings 1-4 and exclude 0s
sumtrials = sum(sortedvals > 0);
deficit = 2*ntrials - sumtrials;

if deficit > 0
    warning(sprintf('Too few images with ratings > 0. Including %d trials rated 0.', deficit));
    sortedvals_g0 = sortedvals(end-(2*ntrials-1):end);
    sortidx_g0 = sortidx(end-(2*ntrials-1):end);
else
    sortedvals_g0 = sortedvals(sortedvals > 0);
    sortidx_g0 = sortidx(sortedvals > 0);
end

% Shuffle within rating category
vals = unique(sortedvals_g0);
randidx = [];

for i = 1:length(vals)
    val = vals(i);
    validx = sortidx_g0(find(sortedvals_g0 == val));
    temp = validx(randperm(length(validx)));
    randidx = vertcat(randidx,temp);
end

% Select first and last n trials 
unhealthyliked = unhealthyimages(randidx(end-(ntrials-1):end));
unhealthydisliked = unhealthyimages(randidx(1:ntrials));

% Randomize images
unhealthyliked_rand = unhealthyliked(randperm(length(unhealthyliked)));
unhealthydisliked_rand = unhealthydisliked(randperm(length(unhealthydisliked)));

% Liked foods: Specify runs and first and last images to select from top images
n = length(healthyliked_rand)/nruns;
first = 1;
last = n; 

    % Create run variables with image positions for unhealthy liked foods
    disp('Adding unhealthy liked foods to run directories')
    for i = 1:nruns
      % specify image positions and images
      evalc(sprintf('run%d_unhealthy_liked = unhealthyliked_rand(first:last)', i));

      % move images
      for j = 1:length(eval(sprintf('run%d_unhealthy_liked',i)))
          runimg = eval(sprintf('run%d_unhealthy_liked{j}', i));
          copyfile(sprintf('%sfoodpics/unhealthy/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
      end

      % update iterators
      first = first + n;
      last = last + n;
    end

% Disliked foods: Specify runs and first and last images to select from top images
n = length(unhealthydisliked_rand)/nruns;
first = 1;
last = n; 

    % Create run variables with image positions for unhealthy liked foods
    disp('Adding unhealthy disliked foods to run directories')
    for i = 1:nruns
      % specify image positions and images
      evalc(sprintf('run%d_unhealthy_disliked = unhealthydisliked_rand(first:last)', i));

      % move images
      for j = 1:length(eval(sprintf('run%d_unhealthy_disliked',i)))
          runimg = eval(sprintf('run%d_unhealthy_disliked{j}', i));
          copyfile(sprintf('%sfoodpics/unhealthy/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
      end

      % update iterators
      first = first + n;
      last = last + n;
    end

% Check images to ensure no image is selected twice
runcheck = who('run*_unhealthy*');
b = [];
for i = 1:length(runcheck)
    a = eval(runcheck{i});
    b = vertcat(b,a);
end
disp(sort(b));

%% Get ratings for selected images
selected = vertcat(healthyliked, healthydisliked, unhealthyliked, unhealthydisliked);
selectedidx = cellfun(@(x) ismember(x, selected), imageinfo{1,3}, 'UniformOutput', 0);
ratings = imageinfo{1,1}(cell2mat(selectedidx) == 1);
images = imageinfo{1,3}(cell2mat(selectedidx) == 1);

%% Save subject trial condition output
suboutput = sprintf('%sinput/%s%s_condinfo.mat',homepath,study,subjid);
save(suboutput, 'run*_*', 'images','ratings')