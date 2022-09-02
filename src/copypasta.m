while (colour ~= "COLOUR") % Change the "COLOUR" to needed colour.
    inputData = read(s,1) % Read input from the myDAQ
    % Begin checking the values.
    redValue =  inputData{1,1}; % Get the first element in inputData (the red photodiode value)
    blueValue = inputData{1,2}; % Get the second element in inputData (the blue photodiode value)

    % Processing data
    if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed) % Check for red
        disp('RED SUS!!');
        colour = "RED";
    elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue) % Check for blue
        disp('BLUE (DA BA DEE DA BA DIE)');
        colour = "BLUE";
    elseif (redValue < maxBlack && blueValue < maxBlack) % This is the win condition
        disp('BLACK');
        colour = "BLACK"; 
    elseif ( redValue > minWhite && blueValue > minWhite)
        disp('WHITE');
        colour = "WHITE";
    else
        disp('NOTHING');
    end % End of if statement
    pause(0.2)
    
end



% Version 2

while (colour ~= "RED")
    outputData = [forward forward up ledStatus];
    write(s,outputData)
    inputData = read(s,1); % Read input from the myDAQ
    % Begin checking the values.
    redValue =  inputData{1,1}; % Get the first element in inputData (the red photodiode value)
    blueValue = inputData{1,2}; % Get the second element in inputData (the blue photodiode value)

    % Processing data
    if (redValue < maxRedOnRed && redValue > minRedOnRed && blueValue < maxBlueOnRed && blueValue > minBlueOnRed) % Check for red
        disp('RED SUS!!');
        colour = "RED";
        ledStatus = on;
        scVar = 1;
    elseif (redValue < maxRedOnBlue && redValue > minRedOnBlue && blueValue < maxBlueOnBlue && blueValue > minBlueOnBlue) % Check for blue
        disp('BLUE (DA BA DEE DA BA DIE)');
        colour = "BLUE";
        ledStatus = on;
        scVar = 2;
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