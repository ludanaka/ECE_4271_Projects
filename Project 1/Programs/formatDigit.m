function digits = formatDigit(digitVector)
%formatDigit.m
%Takes a string of digits and formats the input into a phone number

%If the string of digits is too short, then return 'Error' indicating that
%a valid phone number is not returned.
if length(digitVector) < 10
    digits = 'Error';
else
    digits = [digitVector(1:3) '-' digitVector(4:6) '-' digitVector(7:10)];

end