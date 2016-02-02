function S = modulation(Bits, SNR, mod_size)
%Take in vector of Bits and modulate signal to respective signals according
%to mod size.
%Inputs: Bits (Vectors of 1s and 0s)
%        SNR (Signal Noise Ratio - Linear Value)
%        mod_size (2, 4, or 16 constellation size)
%
%Outputs: S (Converted and modulated Signal)

%Gain access to global variables
global BPSKVector QAM4Vector QAM16Vector BPSKAvgPow QAM4AvgPow ...
    QAM16AvgPow

%Initialize Variables
convertedBits = [];
unNormS = [];
normS = [];
step = log(mod_size)/log(2);
symbolVector = [];
symbolPower = [];

%Determine which Constellation Values to use
switch mod_size
    case 2
       symbolVector = BPSKVector;
       symbolPower = BPSKAvgPow;
    case 4
       symbolVector = QAM4Vector;
       symbolPower = QAM4AvgPow;
    case 16
       symbolVector = QAM16Vector;
       symbolPower = QAM16AvgPow;
end

%Iterate through Bits according to mod_size
for i = 1:step:length(Bits)
    %Check if enough bits remain to convert to a symbol
    if length(Bits(i:end)) >= step
        sample = Bits(i:i+step-1);
        %Convert sample of bits to respective symbol of constellation
        convertedBits = [convertedBits symbolVector(bin2dec(num2str((sample)))+1)];
    end
end

%Normalize converted values by the average symbol power for selected
%constellation
normS = convertedBits ./ sqrt(symbolPower);

%Scale normalized signal by signal power as determined from SNR
S = sqrt(SNR) .* normS;

end