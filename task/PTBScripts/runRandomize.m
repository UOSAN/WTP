%% randomize.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script randomizes the food images, separates them into
% runs, and addes the images to the run directories in task/foodpics/run[X] 
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

% Get food bitmaps file names
bmps = dir(fullfile(homepath, 'foodpics'));

% Specify position of .bmp images
for x = 1:length(bmps)
    y(x) = ~isempty(regexp(bmps(x).name,'\w*bmp$','match'));
end

% Select only .bmp images
bmps = bmps(y);

% Randomize food order
foodrand = randperm(length({bmps(:).name}));

% Create directories if they do not exist
for i = 1:nruns
    rundir = fullfile(sprintf('%sfoodpics/run%d', homepath, i));
    if ~exist(rundir)
        disp(sprintf('Run directory %d did not exist. Creating it now.',i))
        mkdir(rundir);
    end
end

% Remove current images from run directories
for i = 1:nruns
    rundir = dir(fullfile(sprintf('%sfoodpics/run%d', homepath, i)));
    if numel(rundir) > 2
        disp(sprintf('Removing files from run directory %d', i))
        delete(sprintf('%sfoodpics/run%d/*.bmp', homepath, i));
    end
end

% Specify runs and first and last images to select 
n = length({bmps(:).name})/nruns;
first = 1;
last = n; 

% Create run variables with image positions
for i = 1:nruns
  % specify image positions and images
  evalc(sprintf('run%d = foodrand(first:last)', i));
  evalc(sprintf('run%d_images = {bmps(run%d).name}', i, i));
 
  % move images
  for j = 1:length(eval(sprintf('run%d_images',i)))
      runimg = eval(sprintf('run%d_images{j}', i));
      copyfile(sprintf('%sfoodpics/%s',homepath,runimg), sprintf('%sfoodpics/run%d',homepath,i));
  end
  
  % update iterators
  first = first + n;
  last = last + n;
end

% Check positions to ensure no images is selected twice
%sort(horzcat(run1,run2,run3))
%sort(horzcat(run1_images,run2_images,run3_images))