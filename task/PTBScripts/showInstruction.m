function [Resp RT] = showInstruction_function(slidenum,PTBParams,varargin)
% function showInstruction(slidenum, PTBParams, [options])
%
% PTBParams: structure containing useful info for PTB
%
% Option 1: 'SlidePrefix': Name of slide before the number identifier
% default = 'Slide'
%
% Option 2: 'SlideType': 'PNG','JPG','BMP'
% default = 'PNG'
%
% Option 3: 'SlidePath': location of instruction slides
% default = homepath of the calling function
%
% Option 4: 'RequiredKeys': keys accepted by the slide to move on
% default = any key
%
% Author: Cendri Hutcherson
% Date: 9.16.08
%
% Description: Shows bmp file of instruction, and waits for user to press
% any key to continue.

% set defaults
slide_prefix = 'Slide';
slide_type = 'PNG';
required_keys = [];


if nargin > 1
    options_used = varargin(1:2:end);
    option_spec = varargin(2:2:end);

    for i = 1:length(options_used)
        switch options_used{i}
            case 'SlidePrefix'
                slide_prefix = option_spec{i};
            case 'SlideType'
                slide_type = option_spec{i};
            case 'SlidePath'
                PTBParams.homepath = option_spec{i};
            case 'RequiredKeys'
                required_keys = option_spec{i};
                
        end
    end
end
    
% read the image
InsrxScreen = imread([PTBParams.homepath 'Instructions/' slide_prefix sprintf('%02.0f',slidenum) '.' lower(slide_type)], slide_type);
textureIndex=Screen('MakeTexture',PTBParams.win,InsrxScreen);

% resize instruction screen to minimize distortion in the image
imageDims = size(InsrxScreen);
minResizeFactor = min([PTBParams.rect(4)/imageDims(1),PTBParams.rect(3)/imageDims(2)]);

xOffset = floor((PTBParams.rect(3) - imageDims(2) * minResizeFactor)/2);
yOffset = floor((PTBParams.rect(4) - imageDims(1) * minResizeFactor)/2);
destRect = [xOffset, ...
            yOffset, ...
            xOffset + imageDims(2) * minResizeFactor,...
            yOffset + imageDims(1) * minResizeFactor];

% draw the image
Screen('DrawTexture',PTBParams.win,textureIndex, [],destRect); %[],destRect
Screen(PTBParams.win,'Flip');
Screen('Close',textureIndex);

[Resp, RT] = collectResponse([],[],required_keys);