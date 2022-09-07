% THIS CODE WORKS



%Acquire Analog Input Data in the Foreground
d = daqlist;
%Create a session object and save it to the variable, s: 
s = daq('ni')  
%Configure the sampling rate at 1000 scans per second. 
s.Rate = 1000;

addinput(s,'myDAQ1','ai0','Voltage')
addinput(s,'myDAQ1','ai1','Voltage')
% Creates a timetable array with two columns for ai0 and ai1.


maxRedOnBlue = 3;
minRedOnBlue = 1;

maxBlueOnBlue = 4.5;
minBlueOnBlue = 3.1;

maxRedOnRed = 4.5;
minRedOnRed = 3.3;

maxBlueOnRed = 3;
minBlueOnRed = 1;

maxBlack = 2.2;
minWhite = 3;


while (1)
    inputData = read(s,1);
    %stackedplot(input_data)
    redValue =  inputData{1,1};
    blueValue = inputData{1,2};
    
    disp(['Red value: ' num2str(redValue)]);
    disp(['Blue value: ' num2str(blueValue)]);
    if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed) % Check for red
        disp('RED SUS!!');
        output = "RED";
    elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue) % Check for blue
        disp('BLUE (DA BA DEE DA BA DIE)');
        output = "BLUE";
    elseif (redValue < maxBlack && blueValue < maxBlack)
        disp('BLACK');
        output = "BLACK";
    elseif ( redValue > minWhite && blueValue > minWhite)
        disp('WHITE');
        output = "WHITE";
    else
        disp('NOTHING');
    end % End of if statement

    pause(0.05)
end

