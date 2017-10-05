function PTBParams = InitPTB(homepath)
% function [subjid ssnid datafile PTBParams] = InitPTB(homepath)
% 
% Function for initializing parameters at the beginning of a session
%
% homepath: Path name to scripts directory for the study
%
% Author: Cendri Hutcherson
% Last Modified: 5-29-2012

%% housecleaning before the guests arrive
cd(homepath);
clear all; close all; Screen('CloseAll'); 
homepath = [pwd '/'];

%% Get Subject Info 
% Check to make sure aren't about to overwrite duplicate session!
checksubjid = 1;
while checksubjid == 1
    subjid = input('Subject number:  ', 's');
    ssnid = input('Session number (1 = practice, 2 = scan, 3 = behavioral):  ', 's');
    
    if exist([homepath 'SubjectData/' subjid '/Data.' subjid '.' ssnid '.mat'],'file') == 2
        cont = input('WARNING: Datafile already exists!  Overwrite? (y/n)  ','s');
        if cont == 'y'
            checksubjid = 0;
        else
            checksubjid = 1;
        end
    else
        checksubjid = 0;
    end
end   

% Set defaults for subject number and session
if isempty(subjid)
    subjid = '999';
end

if isempty(ssnid)
    ssnid = '1';
end

% create name of datafile where data will be stored    
if ~exist([homepath 'SubjectData/' subjid],'dir')
    mkdir([homepath 'SubjectData/' subjid]);
end


Data.subjid = subjid;
Data.ssnid = ssnid;
Data.time = datestr(now);

datafile = fullfile(homepath, 'SubjectData', subjid, ['Data.',subjid,'.',ssnid,'.mat']);
save(datafile,'Data');

%% Initialize parameters for fMRI
inMRI = input('Run the study using MRI? 0 = no (default), 1 = yes: ');
if isempty(inMRI)
    inMRI = 0;
end
PTBParams.inMRI = inMRI;

% get TR duration
PTBParams.TR = 2; %DCos 2015.4.27, changed default to 2 and removed input format for mock

if isempty(PTBParams.TR)
    PTBParams.TR = 2;
end


%% Initialize PsychToolbox Parameters and save in PTBParams struct

    AssertOpenGL;
    ListenChar(2); % don't print keypresses to screen
    Screen('Preference', 'SkipSyncTests', 1); % use if VBL fails; use this setting on the laptop
    %Screen('Preference', 'VisualDebugLevel',3);

    HideCursor;
    
    %Set screen number
    %screenNum=max(Screen('Screens'));
    screenNum=0;
    
    [w, rect] = Screen('OpenWindow',screenNum);
    %[w, rect] = Screen('OpenWindow',screenNum, [], [0 0 1600 1200]); %DCos 2015.06.25, Use
    %for debugging
        
    ctr = [rect(3)/2, rect(4)/2]; 
    white=WhiteIndex(w);
    black=BlackIndex(w);
    gray = (WhiteIndex(w) + BlackIndex(w))/2;
    ifi = Screen('GetFlipInterval', w);
    
    PTBParams.win = w;
    PTBParams.rect = rect;
    PTBParams.ctr = ctr;
    PTBParams.white = white;
    PTBParams.black = black;
    PTBParams.gray = gray;
    PTBParams.ifi = ifi;
    PTBParams.datafile = datafile;
    PTBParams.homepath = homepath;
    PTBParams.subjid = str2double(subjid);
    PTBParams.ssnid = ssnid;
    PTBParams.keys = initKeys_money;
    PTBParams.inMRI = inMRI;
    
    % set key mapping
    if mod(PTBParams.subjid, 2)
        PTBParams.keyMap = {4 3 2 1};
    else
        PTBParams.keyMap = {1 2 3 4};
    end
    
    % save PTBParams structure
    datafile = fullfile(homepath, 'SubjectData', subjid, ['PTBParams.',subjid,'.',ssnid,'.mat']);
    save(datafile,'PTBParams');
    Screen(w,'TextSize',round(.1*ctr(2)));
    Screen('TextFont',w,'Helvetica');
    Screen('FillRect',w,black);
    
    % used to initialize mousetracking object, otherwise the first time
    % this is called elsewhere it can take up to 300ms, throwing off timing
    [tempx, tempy] = GetMouse(w);
    
    WaitSecs(.5);
%% Seed random number generator 
%(note that different versions of Matlab allow/deprecate different random 
% number generators, so I've incorporated some flexibility here

[v, d] = version; % get Matlab version
if datenum(d) > datenum('April 8, 2011') % compare to first release of rng
    rng(GetSecs, 'twister')
else
    rand('twister',sum(100*clock));
end

