function valid = checkFundamentalLevel(peak1, peak2, fundamentalDFT)
%checkFundamentalLevel.m
%Checks the power lever of the fundamental frequencies in the signal.
%Returns 1, if this signal is a valid tone.  Returns 0, otherwise.

%K is a threshold. The magnitude square of the peaks must be K times
%greater than the sum of the magnitude squares of the remaining frequencies
%in the band for this signal to have enough power to be considered a tone
%and not noise.
k = 7;

valid = ( ( abs(peak1)^2 >= k*(sum((abs(fundamentalDFT(1:4)).^2)) - abs(peak1)^2) ) ...
        && ( ( abs(peak2)^2 >= k*(sum((abs(fundamentalDFT(5:8)).^2)) - abs(peak2)^2) ) ) );

end