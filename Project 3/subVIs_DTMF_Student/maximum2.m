function  [max1 index1 max2 index2] = maximum2(dft)
%Finds the 2 frequencies with maximum power and returns the values and 
%indexes. Compensates for low point DFT by removing false positives when 2 
%signal maximums are side-by-side and both belong to lower 4 frequencies or
%upper 4 frequencies then finding the next maximum.

    %Find 1st 2 maximums and their indexes
    [max1 index1] = max(dft);
    dft(index1) = [];
    [max2 index2t] = max(dft);
    if (index2t >= index1)
        index2 = index2t + 1;
    else 
        index2 = index2t;
    end
    
    %Compensating for overlapping signals due to low window size
    if (abs(index2 - index1) == 1)
        %if 2 peaks are side-by-side
        if ((index1 >= 6 && index2 >= 6) || (index1 <= 5 && index2 <=5))
            %if 2 peaks both belong to upper or lower 4 frequencies
            %find next maximum
            dft(index2t) = [];
            [max2 index2tt] = max(dft);
            if (index2tt >= index2t && index2tt >= index1)
                index2 = index2tt + 2;
            else
                index2 = index2tt;
            end
        end
    end
        
    %Arrange output by index value
    if (index1 > index2)    
        index1t = index1;
        max1t = max1;
        index1 = index2;
        max1 = max2;
        index2 = index1t;
        max2 = max1t;
    end
end