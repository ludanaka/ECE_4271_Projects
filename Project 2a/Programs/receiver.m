function est_sym = receiver(signal, SNR, mod_size)
%Take in corrupted signal and estimate the closest symbols for the
%corrupted data
%Inputs: signal (Corrupted signal S+Noise)
%        SNR (Signal Noise Ration - Linear Value)
%        mod_size (2, 4, or 16 constellation size)
%
%Outputs: est_sym (Estimated symbols)


%Gain access to global variables for constellations
global BPSKVector QAM4Vector QAM16Vector BPSKAvgPow QAM4AvgPow ...
    QAM16AvgPow

%Initialize variables
est_sym = [];
errMag = [];
testSymbol = [];
testPower = [];

%Determine which constellation data to use
switch mod_size
    case 2
        testSymbol = BPSKVector;
        testPower = BPSKAvgPow;
    case 4
        testSymbol = QAM4Vector;
        testPower = QAM4AvgPow;
    case 16
        testSymbol = QAM16Vector;
        testPower = QAM16AvgPow;
end

%Normalize corrupted signal with average signal power and SNR
normSignal = signal ./ (sqrt(SNR / testPower));

%Iterate through corrupted signal
for symbol = normSignal
    %Measure error magnitude between signal and symbols for constellations
    errMag = sqrt(((real(symbol) - real(testSymbol)).^2 + (imag(symbol) - imag(testSymbol)).^2));
    
    %Find the symbol with the minimum error and add that as the estimated
    %symbol.
    [minErr index] = min(errMag);
    est_sym = [est_sym testSymbol(index)];
end

end