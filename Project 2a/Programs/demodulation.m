function est_bits = demodulation(est_sym, mod_size)
%Take in estimated symbols and convert them back to bits.
%Inputs: est_sym (Vectors of estimated symbols)
%        SNR (Signal Noise Ration - Linear Value)
%        mod_size (2, 4, or 16 constellation size)
%
%Outputs: est_bits (Estimated bit values)


%Gain access to global variables for constellations
global BPSKVector QAM4Vector QAM16Vector BPSKAvgPow QAM4AvgPow ...
    QAM16AvgPow

%Initialize variables
bitLength = log(mod_size)/log(2);
symbolVector = [];
est_bits = [];

%Determine which constellation to use
switch mod_size
    case 2
        symbolVector = BPSKVector;
    case 4
        symbolVector = QAM4Vector;
    case 16
        symbolVector = QAM16Vector;
end

%Iterate through estimated symbols
for sym = est_sym
   %Convert symbol to index integer and then to binary string
   index = find(sym == symbolVector);
   binNumber = dec2bin(index-1, bitLength);
   %Convert string to number and add to est_bits
   for i = 1:length(binNumber)
       est_bits = [est_bits str2num(binNumber(i))];
   end
end

end