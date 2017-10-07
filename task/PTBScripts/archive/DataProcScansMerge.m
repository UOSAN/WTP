subjects = {'101' '102' '103' '104' '105' '106' '107' '108' '109' ...
            '111' '112' '113' '114' '115' '116' '117' '118' '119' '120' ...
            '121' '122' '123' '124' '125' '126' '127' '128' '129' '130' ...
            '131' '132' ...
            };

homepath = '~/Documents/GVR/';

cd(homepath)
if exist('Data.AllScans.txt','file')
    delete Data.AllScans.txt
end
for s = 1:length(subjects)
    cd([homepath subjects{s}])
    
    load(['Data.' subjects{s} '.practice.mat']);

    for i = 1:150
        index = searchcell(Data.FoodNum,i);
        Rating(i) = str2num(Data.Resp{index(1)});
    end
    disp(['Appending data for subject ' subjects{s} '...'])
    
    % get names of all datafiles in subject folder
    datafiles = dir('Data*scan*.mat');
    
    for d = 1:length(datafiles)
        % open datafile
        load(datafiles(d).name)
        %  get name of each to-be-made .txt file
%        [savefile y] = regexp(datafiles(d).name,'(.*)\.mat','tokens');
        fid = fopen('../Data.AllScans.txt','a');
        
        % clean data and scrub file of unnecessary variables
        if ~isempty(regexp(datafiles(d).name,'scan','once'))
            for x = 1:length(Data.Resp)
                if ~strcmp(Data.Resp{x},'NULL')
                    Data.Resp{x} = str2double(Data.Resp{x}) - 1;
                    switch subjects{s}
                        case {'101' '123' '124' '127' '128' '129' '132'} %234987 = 123456
                            if Data.Resp{x} > 3
                                Data.Resp{x} = 12 - Data.Resp{x};
                            end
                        case {'102','103','107','108','110','111','114','115','119','120'}% 234789 = 123456
                            if Data.Resp{x} > 3
                                Data.Resp{x} = Data.Resp{x}-2;
                            end
                        case {'104','105','106','109','112','113','116','117','118'}% 432987 = 123456
                            if Data.Resp{x} > 3
                                Data.Resp{x} = 12 - Data.Resp{x};
                            else
                                Data.Resp{x} = 4-Data.Resp{x};
                            end 
                        case {'125' '126' '130' '131' } % 789432 = 123456
                            if Data.Resp{x} > 3
                                Data.Resp{x} = Data.Resp{x} - 5;
                            else
                                Data.Resp{x} = 7 - Data.Resp{x};
                            end
                        case {'121' '122'}%987234 = 123456
                            if Data.Resp{x} > 3
                                Data.Resp{x} = 9 - Data.Resp{x};
                            else
                                Data.Resp{x} = 3 + Data.Resp{x};
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
            if isequal(subjects{s},'101') && d == 1
                fprintf(fid,'Trial\t');
                for n = 1:length(vrbls)
                    fprintf(fid,'%s\t',vrbls{n});
                end
                fprintf(fid,'PreRating\t');
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
                fprintf(fid,'%.0f\t',Rating(Data.FoodNum{i}));
                fprintf(fid,'\n');
                
            end
        end         
    end
    fclose all;
end
