function [Resp, RT] = collectResponse(varargin)
% collectResponse.m
%
% Author: Cendri Hutcherson
% Date: 1.27.09
%
% Description: Waits a specified amount of time for subject to respond,
% records response and RT.
%
% USAGE: collectResponse([waitTime],[moveOn],[allowedKeys])
% 
% EXPLANATION: defaults to infinite waitTime, moving on as soon as any
% button is pressed [i.e. moveOn = 1], with any key press triggering the
% move.  If you wish the program to wait out the remainder of the waitTime
% even if a key has been pressed, use moveOn = 0.  If you wish the program
% to accept as input only certain keys, enter the allowed keys as a string
% (e.g. '12345' or 'bv')

% Set defaults
ListenTime = Inf;
moveOn = 1;
allowedKeys = [];

if length(varargin) >= 1
    ListenTime = varargin{1};
end

if isempty(ListenTime); ListenTime = Inf; end

if length(varargin) >= 2
    moveOn = varargin{2};
end

if isempty(moveOn); moveOn = 1; end

if length(varargin) >= 3
    allowedKeys = varargin{3};
end

if ListenTime == Inf && moveOn ~= 1
    error('Infinite loop: You asked me to wait forever, even AFTER the subject has responded!')
end

% Specifies how long to listen for subject's response
StartWaiting = GetSecs();
Resp = 'NULL';
RT = 'NaN';

while KbCheck(-1)
end

if isempty(allowedKeys)
    while (GetSecs() - StartWaiting) < ListenTime
        [keyDown, secs, key] = KbCheck(-1);
        if keyDown == 1
            Resp = KbName(find(key==1));
            Resp = Resp(1);
            RT = secs-StartWaiting;
            break;
        end
    end
else
    while (GetSecs() - StartWaiting) < ListenTime
        [keyDown, secs, key] = KbCheck(-1);
        if keyDown == 1
            if ~iscell(KbName(find(key==1)))
                Resp = KbName(find(key==1));
                Resp = Resp(1);

                if any(allowedKeys==Resp)
                    RT = secs-StartWaiting;
                    break;
                else
                    Resp = 'NULL';
                end
            end
        end
    end
end

if moveOn ~= 1
    while (GetSecs() - StartWaiting) < ListenTime
    end
end

    