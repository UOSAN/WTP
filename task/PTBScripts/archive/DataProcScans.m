subjects = {'101' '102' '103' '104' '105' '106'};

homepath = '~/Documents/GVR/';

for s = 1:length(subjects)
    cd([homepath subjects{s}])
    disp(['Processing data for subject ' subjects{s} '...'])
    
    % get names of all datafiles in subject folder
    datafiles = dir('Data*scan*.mat');
    
    for d = 1:length(datafiles)
        % open datafile
        load(datafiles(d).name)
        %  get name of each to-be-made .txt file
%        [savefile y] = regexp(datafiles(d).name,'(.*)\.mat','tokens');
        fid = fopen(['Data.' subjects{s} '.AllScans.txt'],'a');
        
        % clean data and scrub file of unnecessary variables
        if ~isempty(regexp(datafiles(d).name,'scan','once'))
            for x = 1:length(Data.Resp)
                if ~strcmp(Data.Resp{x},'NULL')
                    switch subjects{s}
                        case '101'
                            Data.Resp{x} = str2double(Data.Resp{x}) - 1;
                            if Data.Resp{x} > 3
                                Data.Resp{x} = 12 - Data.Resp{x};
                            end
                        case {'102','103'}
                            Data.Resp{x} = str2double(Data.Resp{x}) - 1;
                            if Data.Resp{x} > 3
                                Data.Resp{x} = Data.Resp{x}-1;
                            end
                        case {'104','105','106'}
                            Data.Resp{x} = str2double(Data.Resp{x}) - 1;
                            if Data.Resp{x} > 3
                                Data.Resp{x} = 12 - Data.Resp{x};
                            else
                                Data.Resp{x} = 4-Data.Resp{x};
                            end
                    end
                end
            end
        end
        if isfield(Data,'time')
            Data = rmfield(Data,'time');
        end
        
        if isfield(Data,'EndTime')
            Data = rmfield(Data,'EndTime');
        end

        if isfield(Data,'jitter')
            Data = rmfield(Data,'jitter');
        end
        % print variable names at top of file
        varnames = char(fieldnames(Data));
        vrbls = fieldnames(Data);
        if length(vrbls) > 3
            if d == 1
                fprintf(fid,'Trial\t');
                for n = 1:length(vrbls)
                    fprintf(fid,'%s\t',vrbls{n});
                end
                fprintf(fid,'\n');
            end
            startexist = regexp(vrbls,'StartTime');
            %get # of trials in file
            clear x;
            for i = 1:length(vrbls)
                eval(['x(' num2str(i) ') = length(Data.' vrbls{i} ');']);
            end
            trials = max(x);

            %for each trial, and for each variable, print value of variable on
            %trial

            for i = 1:trials
                fprintf(fid,'%.0f\t%s\t%s\t%2.4f\t',i,num2str(Data.subjid),num2str(Data.ssnid),Data.StartTime{1});
                for m = 4:length(vrbls)
                    eval(['data = Data.' vrbls{m} '{' num2str(i) '};']);
                    classvar = class(data);
                    if isequal(classvar,'double')
                        fprintf(fid,'%.4f\t',data);
                    else
                        fprintf(fid,'%s\t',data);
                    end

                    %fprintf(fid,' ');
                end
                fprintf(fid,'\n');
                
            end
        end         
    end
    fclose all;
end
