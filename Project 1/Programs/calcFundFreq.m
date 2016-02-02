function freq = calcFundFreq(signal)
N = 205;
k = [18, 20, 22, 24, 31, 34, 38, 42];
goertzelOutput = [];

for j = k
    goertzelOutput = [goertzelOutput gfft(signal, N, j)];
end

[peak ind] = max(goertzelOutput);

abs(goertzelOutput)

peak

ind

switch k(ind)
    case 18
        freq = 697;
    case 20
        freq = 770;
    case 22
        freq = 852;
    case 24
        freq = 941;
    case 31
        freq = 1209;
    case 34
        freq = 1336;
    case 38
        freq = 1477;
    case 42
        freq = 1633;
end

end