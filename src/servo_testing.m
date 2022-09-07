% Initialise myDAQ
d = daqlist % Find the myDAQ device.
s = daq('ni') % Create a session on the myDAQ

% DAQ Input channels


inputData = addinput(s,"myDAQ1",'ai0','Voltage') % Analog input for transistor one (red paired)
inputData = addinput(s,"myDAQ1",'ai1','Voltage') % Analog input for transistor two (blue paired)
inputData = addinput(s,"myDAQ1",'port0/line0:2','Digital') % Digital input for the 3 bumper switches on DI:0, DI:1, and DI:2.
% inputData = ['Phototransistor 1' 'Phototransistor 2' 'Bumper 1' 'Bumper 2' 'Bumper 3']

% DAQ Output Channels
outputData = addoutput(s, "myDAQ1", 'port0/line4:7', 'Digital') % Digital output for the two DC motors. M1 on port DO:4, DO:5, M2 on DO:6, DO:7.
outputData = addoutput(s, "myDAQ1", 'ao0', 'Voltage') % Analog output for the servo.
outputData = addoutput(s, "myDAQ1", 'port0/line3', 'Digital') % Output for signalling LED on DO:3.
% outputData = ['DC Motor 1' 'DC Motor 2' 'Servo motor' 'LED']




while true
outputData = [[0 0] [0 0] input('VALUE:') 0];
write(s,outputData)

end
