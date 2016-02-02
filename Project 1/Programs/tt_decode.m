function digits = tt_decode(x)
%tt_decode.m
%Take in a signal composed of dial tones, decode signal, and return a 
%number in the format of NNN-NNN-NNNN.

%Set Sampling Frequency
Fs = 8000;

%Set Analysis Window Size and Time Division
windowSize = 200;
dt = windowSize/Fs;

%Initialize duration variables
toneDuration = 0;
silenceDuration = 0;

%Initialize Digit and Tone variables
currentDigit = 'None';
previousDigit = 'None';
previousTone = '';

%Initialize vector to hold found digits
foundDigit = [];


%Iterate Over Signal using set window size
for startIndex = 1:windowSize:length(x)-1
    
    %Check if enough samples are preset to allow for window analysis
    if (length(x) - startIndex >= windowSize)
        
        %Create windowed sample from signal
        sample = x(startIndex:startIndex+windowSize-1);
        
        %Calculate dual frequencies found in sample if any
        [freq1 freq2] = calcFreq(sample);

        %Check result.  If 0, there is no tone.  Otherwise, decode the
        %frequencies and find digit.
        if (freq1 == 0 && freq2 == 0)
            currentDigit = 'None';
        else
            currentDigit = lookupDigit(freq1, freq2);
        end

        %Check if the current tone found in the window matches the previous
        %tone found in the last window.
        if(strcmp(previousDigit, currentDigit))
            
            %Tones are the same and consistent
            if(strcmp(currentDigit, 'None'))
                %Samples are silence in a row.  Increase silence duration
                silenceDuration = silenceDuration + 2*dt;
            else
                %Samples are same tone.  Increase current tone duration
                toneDuration = toneDuration + dt;
            end
            
        elseif(~strcmp(previousDigit, 'None') && (strcmp(currentDigit,'None')))
            %Tones are different.  Possible that tone has finished or noise
            %has created an illusion of silence, so store the previous tone
            %in mememory, and start measuring silence duration.
            silenceDuration = 0;
            previousTone = previousDigit;
            
        elseif(strcmp(previousDigit, 'None'))
            %Silence is over.  Tone is detected. Reset silence duration.
            silenceDuration = 0;
            
            if (~strcmp(previousTone, currentDigit) && ~strcmp(previousTone, ''))
                %If current tone is different than stored tone and the
                %stored tone exists, this current tone is a wrong
                %measuremnt due to noise.  Ignore this sample.
                currentDigit = previousTone;
                toneDuration = toneDuration + dt;
            end
            
        end
        
        %Check Silence Duration
        if(silenceDuration >= .05)
            
            %Silence duration is long enough to be a pause between tones.
            %Previous tone is potentially a valid digit
            if(toneDuration >= 0.04 && toneDuration <= .40001)
                %Check if tone duration of previous tone is valid.  If so,
                %then a valid dial tone is added to the vector of tones.
                %Reset duration and tone variables.
                foundDigit = [foundDigit previousTone];
                previousTone = '';
                toneDuration = 0;
                silenceDuration = 0;
            end
            
        end
    end
    
    %Store current digit tone as previous digit tone
    previousDigit = currentDigit;
        
end

%Take resulting found digits and format output.
%Will return error if not enough digits are found.
digits = formatDigit(foundDigit);

end