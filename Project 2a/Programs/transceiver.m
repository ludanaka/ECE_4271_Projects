function BER = transceiver(length, SNRdB, mod_size)
%Simulate Transceiver with given data length, SNR (dB), and constellation 
% size.  
% Input: length (length of bits)
%        SNRdB (Desired SNR for Signal)
%        mod_size (2, 4, or 16 constellation size)
%        
% Output: BER (Bit Error Rate)


%Initialize Constellation Tables and Average Signal Powers
%Set as global variables for use in all functions as they are constant.
global BPSKVector QAM4Vector QAM16Vector BPSKAvgPow QAM4AvgPow ...
    QAM16AvgPow

BPSKVector = [1, -1];
QAM4Vector = [1+j, -1+j, -1-j, 1-j];
QAM16Vector = [-3+3j, -3+j, -3-3j, -3-j, -1+3j, -1+j, -1-3j, -1-j, ...
    3+3j, 3+j, 3-3j, 3-j, 1+3j, 1+j, 1-3j, 1-j];


BPSKAvgPow = sum(abs(BPSKVector).^2)/size(BPSKVector,2);
QAM4AvgPow = sum(abs(QAM4Vector).^2)/size(QAM4Vector,2);
QAM16AvgPow = sum(abs(QAM16Vector).^2)/size(QAM16Vector,2);

%Generate Random Vector of Bits
Bits = DataGeneration(length);

%Convert SNR from dB
SNR = 10^(SNRdB/10);

%Take Resulting Bits and Modulate Signal According to Given Parameters
S = modulation(Bits, SNR, mod_size);

%Generate Noise with Size Equal to Converted Signal
Noise = NoiseGeneration(size(S,2));

%Estimate Symbols from Corrupted Signals
est_sym = receiver(S+Noise, SNR, mod_size);

%Convert Estimated Symbols to Bits
est_Bits = demodulation(est_sym, mod_size);

%Calculate Difference and Total Errors
diff = Bits - est_Bits;
totalError = sum(abs(diff));

%Calculate Bit Error Rate
BER = totalError/size(Bits,2);

end