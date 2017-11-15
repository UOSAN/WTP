%% randomize.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script randomizes the food images within each health
% category, separates them into runs, and adds the images to the run
% directories in task/foodpics/run[X] 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housecleaning before the guests arrive
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));

cd(homepath);
clear all; close all; Screen('CloseAll'); 
homepath = [pwd '/'];

%% Get number of runs from user
nruns = input('Number of runs:  ');

%% Sort healthy foods into runs
% Get food bitmaps file names
bmps_healthy = dir(fullfile(homepath, 'foodpics', 'healthy'));

% Specify position of .bmp images
for x = 1:length(bmps_healthy)
    y(x) = ~isempty(regexp(bmps_healthy(x).name,'\w*bmp$','match'));
end

% Select only .bmp images
bmps_healthy = bmps_healthy(y);

% Randomize food order
foodrand = randperm(length({bmps_healthy(:).name}));

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

% Specify runs and first and last images to select 
n = length({bmps_healthy(:).name})/nruns;
first = 1;
last = n; 

% Create run variables with image positions
disp('Adding healthy foods to run directories')
for i = 1:nruns
  % specify image positions and images
  evalc(sprintf('run%d = foodrand(first:last)', i));
  evalc(sprintf('run%d_images = {bmps_healthy(run%d).name}', i, i));
 
  % move images
  for j = 1:length(eval(sprintf('run%d_images',i)))
      runimg = eval(sprintf('run%d_images{j}', i));
      copyfile(sprintf('%sfoodpics/healthy/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
  end
  
  % update iterators
  first = first + n;
  last = last + n;
end

clear x y
% Check positions to ensure no image is selected twice
%sort(horzcat(run1,run2,run3))
%sort(horzcat(run1_images,run2_images,run3_images))

%% Sort unhealthy foods into runs
% Get food bitmaps file names
bmps_unhealthy = dir(fullfile(homepath, 'foodpics', 'unhealthy'));

% Specify position of .bmp images
for x = 1:length(bmps_unhealthy)
    y(x) = ~isempty(regexp(bmps_unhealthy(x).name,'\w*bmp$','match'));
end

% Select only .bmp images
bmps_unhealthy = bmps_unhealthy(y);

% Randomize food order
foodrand = randperm(length({bmps_unhealthy(:).name}));

% Specify runs and first and last images to select 
n = length({bmps_unhealthy(:).name})/nruns;
first = 1;
last = n; 

% Create run variables with image positions
disp('Adding unhealthy foods to run directories')
for i = 1:nruns
  % specify image positions and images
  evalc(sprintf('run%d = foodrand(first:last)', i));
  evalc(sprintf('run%d_images = {bmps_unhealthy(run%d).name}', i, i));
  
  % move images
  for j = 1:length(eval(sprintf('run%d_images',i)))
      runimg = eval(sprintf('run%d_images{j}', i));
      copyfile(sprintf('%sfoodpics/unhealthy/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
  end
  
  % update iterators
  first = first + n;
  last = last + n;
end

% Check positions to ensure no image is selected twice
%sort(horzcat(run1,run2,run3))
%sort(horzcat(run1_images,run2_images,run3_images))