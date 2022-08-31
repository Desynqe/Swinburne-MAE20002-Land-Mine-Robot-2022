%% ROBOT SETUP NOTES
% PHOTOTRANSISTORS
% The blue/green phototransistor is for the Red LED (ai0)
% The purple/brown phototransistor if for the Blue LED (ai1)


%% Variables
% Motor control
forward = [1 0];
backward = [0 1];
left = [backward forward];
right = [forward backward];

halt = [0 0];
down = 7; % 7V to servo 
up = 3; % 3V to servo
on = 1;
off = 0;


% Phototransistor ranges in Volts.
maxRedOnBlue = 0.85;
minRedOnBlue = 0.75;

maxBlueOnBlue = 4.65;
minBlueOnBlue = 4.64;

maxRedOnRed = 4.25;
minRedOnRed = 4.00;

maxBlueOnRed = 1.4;
minBlueOnRed = 1.1;

% Read as valueLightPuck. maxRedBlue means MAX VALUE with the RED LIGHT on
% the BLUE PUCK.
maxBlackTape = 0; % Phototransistor voltage reading the black tape

minBlackTape = 0; % Phototransistor voltage reading the black tape

whiteFloor = 0; % Phototransistor voltage reading the white floor


%% DAQ Input channels
d = daqlist % Find the myDAQ device.
defaultSession = daq('ni') % Create a session on the myDAQ

inputData = addinput(defaultSession,"myDAQ1",'ai0','Voltage') % Analog input for transistor one (red paired)
inputData = addinput(defaultSession,"myDAQ1",'ai1','Voltage') % Analog input for transistor two (blue paired)
inputData = addinput(defaultSession,"myDAQ1",'port0/line0:2','Digital') % Digital input for the 3 bumper switches on DI:0, DI:1, and DI:2.

length(inputData) % debugging
height(inputData) % debugging


% inputData = ['Phototransistor 1' 'Phototransistor 2' 'Bumper 1' 'Bumper 2' 'Bumper 3']

%% DAQ Output Channels
% 
outputData = addoutput(defaultSession, "myDAQ1", 'port0/line4:7', 'Digital') % Digital output for the two DC motors. M1 on port DO:4, DO:5, M2 on DO:6, DO:7.
outputData = addoutput(defaultSession, "myDAQ1", 'ao0', 'Voltage') % Analog output for the servo.
outputData = addoutput(defaultSession, "myDAQ1", 'port0/line3', 'Digital') % Output for signalling LED on DO:3.

% outputData = ['DC Motor 1' 'DC Motor 2' 'Servo motor' 'LED']



%% ENGINEER GAMING








