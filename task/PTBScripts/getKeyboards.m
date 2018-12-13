function [ internal_keyboard, response_device ] = getKeyboards()
% % getKeyboards.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Shows list of available keyboards, asks user to select internal keyboard
% + response device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author: Jolinda Smith
%   written: 20181212
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[indices, names, infos] = GetKeyboardIndices();

choice = 0;
while (choice < 1 || choice > numel(infos))
    for x = 1:numel(infos)
        fprintf('%d. %s %s\n', x, infos{x}.manufacturer, infos{x}.product);
    end
    choice = input('Select internal keyboard: ');
end

internal_keyboard = infos{choice}.index;

fprintf('\n');
choice = 0;
while (choice < 1 || choice > numel(infos))
    for x = 1:numel(infos)
        fprintf('%d. %s %s\n', x, infos{x}.manufacturer, infos{x}.product);
    end
    choice = input('Select response device: ');
end

response_device = infos{choice}.index;

end

 