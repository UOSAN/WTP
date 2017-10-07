function index = searchcell(cellArray,value,varargin)

%  function index = searchcell(cellArray,value,[type])
%  searches a cell array and returns the cell index containing the
%  specified value.  Use type = 'exact' (default) to search for exact match.
%  Use type = 'contains' to search for all cells containing a certain
%  expression (supports regular expression strings)
%
%  Author: Cendri Hutcherson
%  Date: 6.12.10

if isempty(varargin)
    type = 'exact';
else
    type = varargin{1};
end

isTrue = zeros(1,length(cellArray));

switch type
    case 'exact'
        for i = 1:length(cellArray)
            isTrue(i) = isequal(cellArray{i},value);
        end
    case 'contains'
        for i = 1:length(cellArray)
            isTrue(i) = ~isempty(regexp(cellArray{i},value,'once'));
        end
end
index = find(isTrue==1);