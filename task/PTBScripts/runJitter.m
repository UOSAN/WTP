%% runJitter.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script creates the jitter based on the number of
% specified trials and saves a vector of values in WTP/task/input as a .mat
% file (jitter.mat)
% 
% Dependencies: jitter.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housecleaning before the guests arrive
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'PTBScripts') - 1));
addpath(fullfile(homepath,'PTBScripts'));

cd(homepath);
clear all; close all; Screen('CloseAll'); 
homepath = [pwd '/'];

%% Create jitter vector
ntrials = input('Total number of trials per condition (DEV = 16):  ');
Jitter = jitter(2,ntrials,1);  %mean in first position, num trials in second position
Jitter(Jitter > 3) = 3; %truncate max to 3 seconds of jitter
fprintf('The mean jitter is %1.2f\n', mean(Jitter));

%% Save jitter vector
outputfile = fullfile(homepath,'input','jitter.mat');
save(outputfile,'Jitter')
