function Bits = DataGeneration(length)
%Generate random vector of 1s and 0s

Bits = randi(2, 1, length) - 1;

end