% ROBOT SETUP NOTES
% PHOTOTRANSISTORS
% The blue/green phototransistor is for the Red LED (ai0)
% The purple/brown phototransistor if for the Blue LED (ai1)


% Variables
% Motor control
forward = [1 0];
backward = [0 1];
left = [backward forward];
right = [forward backward];
stop = [0 0];
down = 7; % 7V to servo 
up = 3; % 3V to servo

% Signal LED Control
on = 1;
off = 0;
ledStatus = 0;


% Phototransistor ranges in Volts.
maxRedOnBlue = 3;
minRedOnBlue = 1;

maxBlueOnBlue = 5.5;
minBlueOnBlue = 4;

maxRedOnRed = 5;
minRedOnRed = 3.3;

maxBlueOnRed = 3;
minBlueOnRed = 1;

maxBlack = 2;
minWhite = 4;

% Mics variables
degreeMatrix = [-80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80]; % Matrix of search pattern bearings
driveTimeMatrix = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1] % Driving time for each bearing in degreeMatrix
initialTurnTime = 2;
IncTurnTime = 0.25; % Time in seconds to turn 10 degrees
waitTime = 1;
longWaitTime = 2;
puckDropDriveTime = 2;


% DAQ Input channels
d = daqlist % Find the myDAQ device.
s = daq('ni') % Create a session on the myDAQ

inputData = addinput(s,"myDAQ1",'ai0','Voltage') % Analog input for transistor one (red paired)
inputData = addinput(s,"myDAQ1",'ai1','Voltage') % Analog input for transistor two (blue paired)
inputData = addinput(s,"myDAQ1",'port0/line0:2','Digital') % Digital input for the 3 bumper switches on DI:0, DI:1, and DI:2.

length(inputData) % debugging
height(inputData) % debugging


% inputData = ['Phototransistor 1' 'Phototransistor 2' 'Bumper 1' 'Bumper 2' 'Bumper 3']

% DAQ Output Channels
% 
outputData = addoutput(s, "myDAQ1", 'port0/line4:7', 'Digital') % Digital output for the two DC motors. M1 on port DO:4, DO:5, M2 on DO:6, DO:7.
outputData = addoutput(s, "myDAQ1", 'ao0', 'Voltage') % Analog output for the servo.
outputData = addoutput(s, "myDAQ1", 'port0/line3', 'Digital') % Output for signalling LED on DO:3.

% outputData = ['DC Motor 1' 'DC Motor 2' 'Servo motor' 'LED']



% ENGINEER GAMING



% Variables needed:
    % Time in seconds to turn 10 degrees.
    % Time in seconds for each distance driven.



% inputData takes FIVE (5) arguments.
% inputData  = ['Phototransistor 1'  'Phototransistor 2'  'Bumper 1'     'Bumper 2'  'Bumper 3']

% outputData takes FOUR (5) arguments.
% outputData = ['DC Motor 1'         'DC Motor 2'         'Servo motor'  'LED']


%Start by driving back

%outputData = [backward backward 0 1]
%write(s,outputData)
%pause(1);

%outputData = [stop stop 0 1];
%write(s,outputData)
%pause(1);

%outputData = [stop stop 0 0]
%write(s,outputData)
%pause(1);



% Start path
% Reverse into wall

disp('> Aligning with wall');
outputData = [backward backward up off];
write(s,outputData);
pause(1.5);
outputData = [stop stop up off];
write(s,outputData);


% Find black line
%outputData = [forward forward up off]; 
%write(s,outputData); % Start driving foward

colour = "NOTHING"; % Initialise variable to for win condition checking

disp('> Driving to the black line');
while (colour ~= "BLACK") % Drive to black line.
    outputData = [forward forward up ledStatus];
    write(s,outputData); % Start driving foward
    inputData = read(s,1) % Read input from the myDAQ
    % Begin checking the values.
    redValue =  inputData{1,1}; % Get the first element in inputData (the red photodiode value)
    blueValue = inputData{1,2}; % Get the second element in inputData (the blue photodiode value)

    % Processing data
    if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed) % Check for red
        disp('RED SUS!!');
        colour = "RED";
        ledStatus = on;
    elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue) % Check for blue
        disp('BLUE (DA BA DEE DA BA DIE)');
        colour = "BLUE";
        ledStatus = on;
    elseif (redValue < maxBlack && blueValue < maxBlack) % This is the win condition
        disp('BLACK');
        colour = "BLACK"; 
        ledStatus = off;
    elseif ( redValue > minWhite && blueValue > minWhite)
        disp('WHITE');
        colour = "WHITE";
        ledStatus = off;
    else
        disp('NOTHING');
        ledStatus = on; % CHANGE THIS LATER
    end % End of if statement
    pause(0.2)
    
end % End the while loop checking for black tape.

outputData = [stop stop up off];
write(s,outputData); % Stop the robot

lengthOfDegreeMatrix = length(degreeMatrix);
    outputData = [backward forward up off];
    write(s,outputData);
    pause(initialTurnTime)
for (j = 1:16)
    outputData = [forward backward up off];
    write(s,outputData)
    pause(IncTurnTime)
    outputData = [stop stop up off];
    write(s,outputData)
    pause(waitTime)
    
    % Start driving forward to look for puck. ONLY LOOKING FOR RED RIGHT
    % NOW
    disp('> Looking for a red puck...');
    while (colour ~= "RED")
        outputData = [forward forward up ledStatus];
        write(s,outputData)
        inputData = read(s,1); % Read input from the myDAQ
        % Begin checking the values.
        redValue =  inputData{1,1}; % Get the first element in inputData (the red photodiode value)
        blueValue = inputData{1,2}; % Get the second element in inputData (the blue photodiode value)
    
        % Processing data
        if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed) % Check for red
            %disp('RED SUS!!');
            colour = "RED";
            ledStatus = on;
            scVar = 1;
        elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue) % Check for blue
            %disp('BLUE (DA BA DEE DA BA DIE)');
            colour = "BLUE";
            ledStatus = on;
            scVar = 2;
        elseif (redValue < maxBlack && blueValue < maxBlack) % This is the win condition
            %disp('BLACK');
            colour = "BLACK"; 
            ledStatus = off;
        elseif ( redValue > minWhite && blueValue > minWhite)
            %disp('WHITE');
            colour = "WHITE";
            ledStatus = off;
        else
            %disp('NOTHING');
            ledStatus = on; % CHANGE THIS LATER
        end % End of if statement
            pause(0.005) % Repeat at 200Hz
            
    end % End while loop looking for red puck
        outputData = [stop stop down on];
        write(s,outputData);
        pause(waitTime);


    disp('> Looking for the black line...');   
    while (colour ~= "BLACK")
        outputData = [backward backward down on];
        write(s,outputData)
        inputData = read(s,1); % Read input from the myDAQ
        % Begin checking the values.
        redValue =  inputData{1,1}; % Get the first element in inputData (the red photodiode value)
        blueValue = inputData{1,2}; % Get the second element in inputData (the blue photodiode value)
    
        % Processing data
        if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed) % Check for red
            %disp('RED SUS!!');
            colour = "RED";
        elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue) % Check for blue
            %disp('BLUE (DA BA DEE DA BA DIE)');
            colour = "BLUE";
        elseif (redValue < maxBlack && blueValue < maxBlack) % This is the win condition
            %disp('BLACK');
            colour = "BLACK"; 
        elseif ( redValue > minWhite && blueValue > minWhite)
            %disp('WHITE');
            colour = "WHITE";
        else
            disp('NOTHING');
        end % End of if statement

    end % End of while loop looking for black line
    outputData = [stop stop down on];
    write(s,outputData);
    pause(waitTime);

    % Turn 180 degrees
    disp('> Turning 180 degrees');
    outputData = [forward backward down on];
    write(s,outputData);
    pause(IncTurnTime*18);
    
    disp('> Moving lolololol');
    outputData = [forward forward down on];
    write(s,outputData);
    pause(puckDropDriveTime);

    % Drop puck
    disp('> Dropping puck');
    outputData = [stop stop up on];
    write(s,outputData);
    pause(longWaitTime*5);

    disp('> Moving lolololol');
    outputData = [backward backward down on];
    write(s,outputData);
    pause(puckDropDriveTime);

    % Turn back 180 degrees
    disp('> Turning 180 degrees');
    outputData = [backward forward up on];
    write(s,outputData);
    pause(IncTurnTime*18);

    % REPEAT THE FOR LOOP! LETS FUCKING GOOOOOOOOOOOOO
end


