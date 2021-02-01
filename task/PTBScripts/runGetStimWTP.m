%% runGetStimWTP.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script selects food images based on their ratings 
% and health category, randomizes them, separates them into runs, and adds
% the images to the run directories in task/foodpics/run[X] 
% 
% Inputs: Ratings .csv file in dropbox path (defined below) with the 
% following name: [study][subject ID]_ratings.csv (e.g. DEV999_ratings.csv)
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

%% Get study, subject id, and session number from user
study = 'DEV'; %removed user input for convenience 
subjid = input('Subject number (3 digits):  ', 's');
ssnid = input('Session number (1-5):  ', 's');

% specify number of trials and runs
% nruns = input('Number of runs (DEV = 4):  ');
% ntrials = input('Total number of trials per condition (DEV = 16):  ');
if str2num(ssnid) < 3
    nruns = 4; % scanner sessions = 1 & 2
else 
    nruns = 2; % behavioral sessions = 3-5
end

if str2num(ssnid) < 3
    ntrials = 16; % scanner sessions = 1 & 2
else 
    ntrials = 32; % behavioral sessions = 3-5
end

% calculate number of trials per image type
ncond1 = 2; % healthy + unhealthy
ncond2 = 2; % liked + disliked
cond1trials = (nruns*ntrials) / ncond1; % number of healthy and unhealthy images
condtrials = (nruns*ntrials) / (ncond1*ncond2); % number of liked and disliked healthy and unhealthy images

%% Load image info
% Define input and output dropbox path
dxpath = '~/Dropbox (University of Oregon)/UO-SAN Lab/Berkman Lab/Devaluation/Tasks/ImageSelection/output/WTP'; % check this
dxpathout = '~/Dropbox (University of Oregon)/UO-SAN Lab/Berkman Lab/Devaluation/Tasks/WTP/output';

% Define subject input file
subinput = sprintf('%s/%s%s_ratings.csv',dxpath,study,subjid);

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

%% Create run directories and remove old images and unnecessary run directories
% Remove current images from run directories
nrundirs = numel(dir(sprintf('%sfoodpics/run*',homepath)));
for i = 1:nrundirs
    rundir = dir(fullfile(sprintf('%sfoodpics/run%d', homepath, i)));
    if numel(rundir) > 2
        disp(sprintf('Removing files from run directory %d',i))
        delete(sprintf('%sfoodpics/run%d/*.bmp', homepath, i));
    end
end

% Remove unnecessary run directories
for i = 1:nrundirs
    if i > nruns
        disp(sprintf('Removing unnecessary run directory %d',i))
        rundir = (sprintf('%sfoodpics/run%d', homepath, i));
        rmdir(rundir)
    end
end

% Create directories if they do not exist
for i = 1:nruns
    rundir = fullfile(sprintf('%sfoodpics/run%d', homepath, i));
    if ~exist(rundir)
        disp(sprintf('Run directory %d did not exist. Creating it now',i))
        mkdir(rundir);
    end 
end

%% Sort healthy foods into runs
% Select healthy images (healthy = 1, unhealthy = 0)
healthyidx = imageinfo{1,2} == 1;
healthyimages = imageinfo{1,3}(healthyidx);
healthyratings = imageinfo{1,1}(healthyidx);

% Code NaN ratings as 0 for sorting
healthyratingsNaN = healthyratings;
if sum(isnan(healthyratingsNaN)) > 0
    warning('Converting NaNs to 0');
    healthyratingsNaN(isnan(healthyratingsNaN)) = 0;
end

% Sort images by rating (ascending 1-4)
[sortedvals, sortidx] = sort(healthyratingsNaN);

% Check if there are enough trials with ratings 1-4 and exclude 0s
sumtrials = sum(sortedvals > 0);
deficit = cond1trials - sumtrials;

if deficit > 0
    warning(sprintf('Too few images with ratings > 0. Including %d trials rated 0.', deficit));
    sortedvals_g0 = sortedvals(end-(cond1trials-1):end);
    sortidx_g0 = sortidx(end-(cond1trials-1):end);
else
    sortedvals_g0 = sortedvals(sortedvals > 0);
    sortidx_g0 = sortidx(sortedvals > 0);
end

% Shuffle within rating category
vals = unique(sortedvals_g0);
randidx = [];

for i = 1:length(vals)
    val = vals(i);
    validx = sortidx_g0(sortedvals_g0 == val);
    temp = validx(randperm(length(validx)));
    randidx = vertcat(randidx,temp);
end

% Select first and last n trials 
healthyliked = healthyimages(randidx(end-(condtrials-1):end));
healthydisliked = healthyimages(randidx(1:condtrials));

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

[unique_b, i] = unique(b,'first');
duplicates = b(not(ismember(1:numel(b),i)));

if ~isempty(duplicates)
    disp(sort(b));
    error('Duplicate files found. Please check ensure there are enough healthy stimuli available.');
end

%% Sort unhealthy foods into runs
% Select unhealthy images (healthy = 1, unhealthy = 0)
unhealthyidx = imageinfo{1,2} == 0;
unhealthyimages = imageinfo{1,3}(unhealthyidx);
unhealthyratings = imageinfo{1,1}(unhealthyidx);

% Code NaN ratings as 0 for sorting
unhealthyratingsNaN = unhealthyratings;
if sum(isnan(unhealthyratingsNaN)) > 0
    warning('Converting NaNs to 0');
    unhealthyratingsNaN(isnan(unhealthyratingsNaN)) = 0;
end

% Sort images by rating (ascending 1-4)
[sortedvals, sortidx] = sort(unhealthyratingsNaN);

% Check if there are enough trials with ratings 1-4 and exclude 0s
sumtrials = sum(sortedvals > 0);
deficit = cond1trials - sumtrials;

if deficit > 0
    warning(sprintf('Too few images with ratings > 0. Including %d trials rated 0.', deficit));
    sortedvals_g0 = sortedvals(end-(cond1trials-1):end);
    sortidx_g0 = sortidx(end-(cond1trials-1):end);
else
    sortedvals_g0 = sortedvals(sortedvals > 0);
    sortidx_g0 = sortidx(sortedvals > 0);
end

% Shuffle within rating category
vals = unique(sortedvals_g0);
randidx = [];

for i = 1:length(vals)
    val = vals(i);
    validx = sortidx_g0(sortedvals_g0 == val);
    temp = validx(randperm(length(validx)));
    randidx = vertcat(randidx,temp);
end

% Select first and last n trials 
unhealthyliked = unhealthyimages(randidx(end-(condtrials-1):end));
unhealthydisliked = unhealthyimages(randidx(1:condtrials));

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
runcheck = who('run*_healthy*');
b = [];
for i = 1:length(runcheck)
    a = eval(runcheck{i});
    b = vertcat(b,a);
end

[unique_b, i] = unique(b,'first');
duplicates = b(not(ismember(1:numel(b),i)));

if ~isempty(duplicates)
    disp(sort(b));
    error('Duplicate files found. Please check ensure there are enough unhealthy stimuli available.');
end

%% Get ratings for selected images
selected = vertcat(healthyliked, healthydisliked, unhealthyliked, unhealthydisliked);
selectedidx = cellfun(@(x) ismember(x, selected), imageinfo{1,3}, 'UniformOutput', 0);
ratings = imageinfo{1,1}(cell2mat(selectedidx) == 1);
images = imageinfo{1,3}(cell2mat(selectedidx) == 1);

%% Print number of runs and images in each run
for i = 1:nruns
    n = numel(dir(sprintf('%sfoodpics/run%d/*.bmp',homepath,i)));
    fprintf('Run directory %d contains %d images\n',i,n);
end

%% Save subject trial condition output
suboutput = sprintf('%sinput/%s%s_%s_condinfo.mat',homepath,study,subjid,ssnid);
save(suboutput, 'run*_*', 'images','ratings')

%% Copy to dropbox
subdir = sprintf('%s/DEV%s/', dxpathout, subjid);
if ~exist(subdir)
    mkdir(subdir);
end
copyfile(suboutput, subdir);
disp(sprintf('Stimulus key copied to %s',subdir));

%% Clean up
clear all; close all; Screen('CloseAll'); 