function [freq1, freq2] = calcFreq(signal)
%calcFreq.m
%Calculate Frequencies in the given signal, and determine which frequencies
%for dial tones are valid and present if any.

%Initialze N and k
N = 205;
k = [18, 20, 22, 24, 31, 34, 38, 42];
goertzelOutput = [];

%Iterate through different k values, and determine Goertzel DFT outputs at
%each k.
for j = k
    goertzelOutput = [goertzelOutput gfft(signal, N, j)];
end

%Calculate peaks from low and high bands
[peak1 ind1] = max(goertzelOutput(1:4));
[peak2 ind2] = max(goertzelOutput(5:8));

%Calculate low and high indices
low = k(ind1);
high = k(ind2+4);

%Calculate the validity of the Fundamental Frequency levels and the Harmonic
%Frequency levels for the given signal at the maximum frequencies.
fundValid = checkFundamentalLevel(peak1, peak2, goertzelOutput);
harmValid = checkHarmonicLevel(signal, goertzelOutput, ind1, ind2+4);

%Check valid variables
if (harmValid && fundValid)
    %If signal is valid in fundamental frequency strength and has
    %negligible harmonics, it is a valid signal, and its low band and high
    %band frequencies are calculated.
    switch low
        case 18
            freq1 = 697;
        case 20
            freq1 = 770;
        case 22
            freq1 = 852;
        case 24
            freq1 = 941;
    end

    switch high
        case 31
            freq2 = 1209;
        case 34
            freq2 = 1336;
        case 38
            freq2 = 1477;
        case 42
            freq2 = 1633;
    end
else
    %Signal is not valid. So, return 0.
    freq1 = 0;
    freq2 = 0;
end

end