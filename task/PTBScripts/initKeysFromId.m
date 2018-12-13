function [ keys ] = initKeys(deviceNum, trigger)
% % INITKEYS.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   sets device values in a structure called keys 
%   given the id number of the device.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author: wem3
%   acknowledgements: Andrew Cho
%   modified: Jolinda Smith
%   written: 141031
%   modified: 20181212
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


keys.bbox = deviceNum;

devices=PsychHID('Devices');
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
keys.trigger = trigger;

keys.device = devices(deviceNum);
keys.deviceNum = deviceNum;
keys.space=KbName('SPACE');
keys.esc=KbName('ESCAPE');
keys.right=KbName('RightArrow');
keys.left=KbName('LeftArrow');
keys.up=KbName('UpArrow');
keys.down=KbName('DownArrow');
keys.shift=KbName('RightShift');
keys.kill = KbName('k');

end

 