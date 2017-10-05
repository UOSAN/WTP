function [picLoc, resizeFactor] = findPicLoc(picSize, picCtr,PTBParams,varargin)
% function picLoc = findPicLoc(picSize, picCtr,PTBParams,[mode],[scalingFactor])
% given a texture of a particular size, a desired location for center of
% the picture, and a scaling factor, finds screen coordinates for use with
% Screen('DrawTexture')
%
% mode: 
%  'PicPct' (default), scales the picture as a percentage of the original 
%       picture size in pixels
%  'ScreenPct', scales the picture to a percentage of the screen (N.B) if
%  the screen dimensions and picture dimensions do not match, the function
%  finds a 'middle-ground' scaling factor based on both the x- and
%  y-dimensions
%
% scalingFactor: 
%  given as a fraction (e.g. 50% = .5)
%
% Author: Cendri Hutcherson
% Last Modified: May 21, 2013


if isempty(varargin)
    mode = 'PicPct';
    resizeFactor = 1;
else
    mode = varargin{1};
    
    switch mode
        case 'PicPct'
            resizeFactor = varargin{2};
        case 'ScreenPct'
            % get current percentages (width and height) of screen real
            % estate
            currentPct = picSize([2,1])./(PTBParams.ctr * 2);
            % approximate resizeFactor by rescaling mean of current % by
            % desired %
            resizeFactor = varargin{2}/mean(currentPct);
    end
end



ctrPt = [PTBParams.ctr(1) * picCtr(1)*2,...
         PTBParams.ctr(2) * picCtr(2)*2,...
         PTBParams.ctr(1) * picCtr(1)*2,...
         PTBParams.ctr(2) * picCtr(2)*2];
picSize = (picSize([2,1]) * resizeFactor)/2;

picLoc = ctrPt + [-1*picSize,picSize];


