function Noise = NoiseGeneration(length)
%Generate White Gaussian Noise with standard deviation of 1 with size of
%length.

Noise = (randn(1, length) + j.*randn(1, length)) ./ sqrt(2);

end