function logData(datafile, runNum, trial,varargin)
%--------------------------------------------------------------------------
% USAGE: logData(datafile, trial, [recordedVariables],...)
%
% Creates a Data struct with each field representing a variable that has
% been specified to be saved.
%
% datafile: Path and name of subject's datafile. Should be a .mat file, 
% containing a Data structure for that subject.
% 
% trial: Trial number for recording. If variable is a single instance (e.g.
% group membership, date run, etc., trial = 1
%
% recordedVariables:
%
% USAGE 1: logData(datafile, [trial], var1, var2, var3)
%
% This usage will write the variables var1 etc. into the Data structure, 
% using the names 'var1', etc.
%
% USAGE 2: logData(datafile, [trial], Struct)
%
% This usage is a more compact way of logging the data. Struct contains all
% the variables for that trial, each with its own field (e.g. Struct.var1,
% Struct.var2 etc.). Each field in Struct will be appended to the Data
% struct.
%--------------------------------------------------------------------------


% If requested datafile doesn't exist, create a default to save data to.
if exist(datafile,'file')
    
    load(datafile); % loads the Data structure into memory for appending
    
else
    
    warning(['Requested datafile (', datafile, ') does not exist!', ...
             'Data will be saved to the file Data.Default.mat in the ', ...
             'current directory.']);
    datafile = 'Data.Default.mat';
    
end

% Save requested variables
for VAR = 1:(nargin - 3)
    if ~isstruct(varargin{VAR})
        
        % USAGE 1
        structureName = sprintf('Data.%s.',runNum);
        eval([structureName inputname(VAR + 3) '{' num2str(trial) '} = varargin{' ...
            num2str(VAR) '};']);
        
    else
        
        % USAGE 2
        TempStruct = varargin{VAR};
        varnames = fieldnames(TempStruct);
        
        for FIELD = 1:length(varnames)
            
            eval(['TempStruct.' varnames(FIELD) '{' num2str(trial) '} = TempStruct.' ...
            varnames(FIELD) ';']);
        end
        
    end
        
end

save(datafile,'Data');
    