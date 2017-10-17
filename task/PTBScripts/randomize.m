%% Randomize.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script randomizes the food images, separates them into
% runs, and addes the images to the run directories in task/foodpics/run[X] 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
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

% Specify runs and first and last images to select 
n = length({bmps(:).name})/PTBParams.nruns;
first = 1;
last = n; 

% Create run variables with image positions
for i = 1:PTBParams.nruns
  % specify image positions and images
  eval(sprintf('run%d = foodrand(first:last)', i));
  eval(sprintf('run%d_images = {bmps(run%d).name}', i, i));
 
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