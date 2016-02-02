function valid = checkHarmonicLevel(signal, fundamentalDFT, ind1, ind2)
%checkHarmonicLevel.m
%Checks the Harmonics present in the signal.  Returns 1, if harmonics are
%negligible.  Returns 0, if harmonics are too high indicating that this is
%not a pure tone.

%Initializes N and k
N = 201;
k = [35, 39, 43, 47, 61, 67, 74, 82];
harmonics = [];

%Sets a threshold value.  If the sum of the magnitude square of harmonics
%is less than this value, then the harmonics are negligible.
thresh = 150;

%Iterate through k values, and calculate DFT for each harmonic frequency
for j = k
    harmonics = [harmonics gfft(signal, N, j)];
end

%Calculate the ratio of harmonic to fundamental for the max values.  If the
%ratio is too high, then this signal is not a pure tone.
ratio = mean(abs(harmonics([ind1 ind2])) ./ abs(fundamentalDFT([ind1 ind2])));

%Valid if the harmonics meet one of these condiditons.
valid = (sum(harmonics.^2) < thresh) || (ratio < .15);

end