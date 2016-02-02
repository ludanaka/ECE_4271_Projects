function digit = lookupDigit(f1, f2)
%lookupDigit.m
%Takes frequencies and returns the corresponding digit for those two
%frequencies.

%Initialize Digit Lookup Table
digitTable = ['1', '2', '3', 'A';
              '4', '5', '6', 'B';
              '7', '8', '9', 'C';
              '*', '0', '#', 'D'];
          
%Using given frequencies, determine row and column of digit table                    
switch f1
    case 697
        i = 1;
    case 770
        i = 2;
    case 852
        i = 3;
    case 941
        i = 4;
end

switch f2
    case 1209
        j = 1;
    case 1336
        j = 2;
    case 1477
        j = 3;
    case 1633
        j = 4;
end

%Find the indicated digit
digit = digitTable(i,j);

end