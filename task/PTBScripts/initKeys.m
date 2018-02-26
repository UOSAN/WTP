function [ keys ] = initKeys(inMRI)
% % INITKEYS.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   queries PsychHID('Devices') & sets device values
%   in a structure called keys.
%
% note: you'll need to replace the vendorID with whatever works for your
% keyboard. Find out by doing >> devices = PsychHID('Devices') and poking
% around the devices structure
% kludge for screen during multiband calibration (shortened for debug)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author: wem3
%   acknowledgements: Andrew Cho
%   written: 141031
%   modified: 141104 ~wem3
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set up button box / keyboard
devices=PsychHID('Devices');
for deviceCount=1:length(devices),
    if inMRI == 1
      % the lcni button box has the usageName 'Keyboard' and the product 'Xkeys'
      if (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).product,'Xkeys')),
        keys.bbox = deviceCount;
        keys.trigger = 52; % trigger pulse / TR signal key ('`') for LCNI scanner
        fprintf('button box detected\n using device #%d: %s\n',deviceCount,devices(deviceCount).product);
        break,
      end
    else
      % iMac setup has the usagename 'Keyboard' and the manufacturer 'Apple'
      if (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).manufacturer,'Apple')), %DCos 2015.5.8, replaced 'Microsoft'
        keys.bbox = deviceCount;
        keys.trigger = KbName('SPACE'); % use spacebar as KbTrigger
        fprintf('Using Device #%d: external %s\n',deviceCount,devices(deviceCount).usageName);
        break,
      % MacBook laptop setup has the usagename 'Keyboard' and the product 'Apple Internal Keyboard / Trackpad'
      elseif (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).product,'Apple Internal Keyboard / Trackpad')),
        keys.bbox = deviceCount;
        keys.trigger = KbName('SPACE'); % use spacebar as KbTrigger
        fprintf('Using Device #%d: internal %s\n',deviceCount,devices(deviceCount).usageName);
        break,
      end
    end
end

keys.b1 = KbName('1!');   % Keyboard 1
keys.b2 = KbName('2@');   % Keyboard 2
keys.b3 = KbName('3#');   % Keyboard 3
keys.b4 = KbName('4$');   % Keyboard 4
keys.b5 = KbName('5%');   % Keyboard 5
keys.b6 = KbName('6^');   % Keyboard 6
keys.b7 = KbName('7&');   % Keyboard 7
keys.b8 = KbName('8*');   % Keyboard 8
keys.b9 = KbName('9(');   % Keyboard 9
keys.b0 = KbName('0)');   % Keyboard 0
keys.buttons = (30:39);

keys.device = devices(deviceCount);
keys.deviceNum = deviceCount;
keys.space=KbName('SPACE');
keys.esc=KbName('ESCAPE');
keys.right=KbName('RightArrow');
keys.left=KbName('LeftArrow');
keys.up=KbName('UpArrow');
keys.down=KbName('DownArrow');
keys.shift=KbName('RightShift');
keys.kill = KbName('k');

% to disable detection of the trigger pulse:
% olddisabledkeys=DisableKeysForKbCheck([KbName(52), KbName('0)')])

% to re-enable detection of the trigger pulse

% olddisabledkeys=DisableKeysForKbCheck([])
end