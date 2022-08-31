%Acquire Analog Input Data in the Foreground
d = daqlist;
%Create a session object and save it to the variable, s: 
s = daq('ni')  
%Configure the sampling rate at 1000 scans per second. 
s.Rate = 1000;

addinput(s,'myDAQ1','ai0','Voltage')
addinput(s,'myDAQ1','ai1','Voltage')
% Creates a timetable array with two columns for ai0 and ai1.


maxRedOnBlue = 0.85;
minRedOnBlue = 0.75;

maxBlueOnBlue = 4.65;
minBlueOnBlue = 4.64;

maxRedOnRed = 4.3;
minRedOnRed = 4.00;

maxBlueOnRed = 1.4;
minBlueOnRed = 1.1;


while (1)
    inputData = read(s,1);
    %stackedplot(input_data)
    redValue =  inputData{1,1};
    blueValue = inputData{1,2};
    disp(['Red value: ' num2str(redValue)]);
    disp(['Blue value: ' num2str(blueValue)]);
    if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed)
        disp('RED RED RED RED RED RED RED RED');
    elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue)
        disp('BLUE BLUE BLUE BLUE BLUE BLUE BLUE BLUE');
    else
        disp('NOTHING');
    end
    pause(0.2)
end

