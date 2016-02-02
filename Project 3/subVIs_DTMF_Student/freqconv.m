function digits = freqconv(freq)
%Converts 2 by N matrix of sampled windows(freq) of DTMF frequencies to 
%their corresponding N numbers and consolidates the N numbers to actual 
%numbers dialed

    output = [];
    [r c] = size(freq);
    %converts each column of freq to a dial number
    for (N = 1:c)
        if (freq(1,N) == 697) && (freq(2,N) == 1209)
            output = [output '1'];
        elseif (freq(1,N) == 697) && (freq(2,N) == 1336)
            output = [output '2'];
        elseif (freq(1,N) == 697) && (freq(2,N) == 1477)
            output = [output '3'];
        elseif (freq(1,N) == 697) && (freq(2,N) == 1633)
            output = [output 'A'];   
        elseif (freq(1,N) == 770) && (freq(2,N) == 1209)
            output = [output '4'];
        elseif (freq(1,N) == 770) && (freq(2,N) == 1336)
            output = [output '5'];
        elseif (freq(1,N) == 770) && (freq(2,N) == 1477)
            output = [output '6'];
        elseif (freq(1,N) == 770) && (freq(2,N) == 1633)
            output = [output 'B'];
        elseif (freq(1,N) == 852) && (freq(2,N) == 1209)
            output = [output '7'];
        elseif (freq(1,N) == 852) && (freq(2,N) == 1336)
            output = [output '8'];
        elseif (freq(1,N) == 852) && (freq(2,N) == 1477)
            output = [output '9'];
        elseif (freq(1,N) == 852) && (freq(2,N) == 1633)
            output = [output 'C'];
        elseif (freq(1,N) == 941) && (freq(2,N) == 1209)
            output = [output '*'];
        elseif (freq(1,N) == 941) && (freq(2,N) == 1336)
            output = [output '0'];
        elseif (freq(1,N) == 941) && (freq(2,N) == 1477)
            output = [output '#'];
        elseif (freq(1,N) == 941) && (freq(2,N) == 1633)
            output = [output 'D'];
        elseif (freq(1,N) == 0) && (freq(2,N) == 0)
            output = [output '_']; %pause
        elseif (freq(1,N) == 440) || (freq(2,N) == 440)
            output = [output 'T']; %dialtone
        end    
    end
    %consolidates vector of sampled windows into actual numbers dialed
    %number length >= 3 -> register as number input
    %pause length >= 1 -> wait for next number input
    digits = [];
    nexttone = false; %do not register number input until first pause
    
    digitcount = 0;
    for (n = 1:length(output)-3)
        %traverse vector of sampled windows and take 3 samples each time
        temp = output(n); 
        temp2 = output(n+1);
        temp3 = output(n+2);
        
        if (temp == 'T') && (digitcount == 0) 
            %do no accept digits coming before the dialtone
            nexttone = false;
        elseif (temp == '_') && (temp == temp2) && (temp == temp3)
            %test for pause at least 3 samples-> next digit
            nexttone = true; %wait for next digit
        elseif (temp == temp2 && temp2 == temp3) && (nexttone == true)
            %test for next digit at least 3 samples long 
            digits = [digits temp];
            digitcount = digitcount + 1;
            if (digitcount == 3) || (digitcount == 6)
                digits = [digits '-'];
            end
            nexttone = false; %ignore all digits until a pause occurs
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    