% Possible keys pressed
KEYS = ['1','2','3','A';
        '4','5','6','B';
        '7','8','9','C';
        '*','0','#','D'];
FS = 8000; % Sampling Frequency

% 12 DTMF frequencies, and values of N used in gfft algorithm
FREQS  = [350,440,480,620,697,770,852,941,1209,1336,1477,1633];
GFFT_N = [320,200,250,258,264,187,169,255, 204, 263, 260, 240];
% Computes closest value of k to each DTMF freq
GFFT_K = round(GFFT_N.*FREQS/FS); 
NF = length(FREQS); % Number of DTMF frequencies (12)

L = length(x); % Length of input signal
W = 320; % Width of window in # of samples
V = 280; % Overlap between consecutive windows
AMP = 0.25; % Minimum normalized amplitude of gfft for freq to be detected 
Q = floor((L-W)/(W-V)); % Number of analysis windows
nn = 1:W; % Indicies of current window

% Vectors keeping track of low&high freqs and their duration in # of windows
lowFreqsDur = [];
highFreqsDur = [];
duration = [];
lowFprev = 1;
highFprev = 1;

% Loop over each window
for i = 1:Q, 
    y = x(nn); % Window of input signal
    Yrms = sqrt(conj(y)*y'/length(y)); % RMS value of the window
    A = zeros(1,NF); 
    for j = 1:NF, % For each of the 12 DTMF freqs
        N = GFFT_N(j);
        K = GFFT_K(j); 
        % Use first N samples and last N samples in window, store the larger gfft magnitude
        A1 = gfft(y(1:N),N,K); 
        A2 = gfft(y(end-N+1:end),N,K);
        A(j) = max(abs(A1),abs(A2))/N;
    end
    % Sort low and high sets of DTMF freqs by gfft magnitude
    [XFL,indexL] = sort(A(5:8),'descend'); 
    [XFH,indexH] = sort(A(9:12),'descend');
    if(A(1) > AMP*Yrms && A(2) > AMP*Yrms) 
        % Detects Dial Tone (350+440)
        lowF = 350;
        highF = 440;
        freqsdetected(:,i) = [lowF;highF];
    elseif(XFL(1) > AMP*Yrms && XFH(1) > AMP*Yrms) 
        % Check if 1 low & 1 high freq present
        % If at least 1 low and 1 high freq present, record it
        lowF  = FREQS(indexL(1)+4);
        highF = FREQS(indexH(1)+8);        
    else
        % Else record no DTMF tone present
        lowF  = 0;
        highF = 0;
    end
    
    % Records low freq, high freq, and # of consecutive windows 
    % with same low&high freq pair
    if(lowF ~= lowFprev || highF ~= highFprev)
        lowFreqsDur  = [lowFreqsDur; lowF];
        highFreqsDur = [highFreqsDur;highF];
        duration = [duration;1];
        lowFprev  = lowF;
        highFprev = highF;
    else
        duration(end) = duration(end)+1;
    end
    
    nn = nn + (W-V); % Moves window indices to next window
end

% If a DTMF tone lasts for 4 or fewer windows, ignore it
m = 1; 
while(m <= length(duration)-1)
    if(lowFreqsDur(m)~=0 && highFreqsDur(m)~=0 && duration(m) <= 4)
        lowFreqsDur(m)  = [];
        highFreqsDur(m) = [];
        duration(m) = [];
        m = m-1;
    end
    m = m+1;
end

% If a DTMF tone is interrupted by quiet period of 3 or fewer windows, 
% ignore the interruption, and count the seperated tones as one tone
m = 2; 
while(m <= length(duration)-1)
    if(lowFreqsDur(m)==0 && highFreqsDur(m)==0)
        if(duration(m)<=3 && lowFreqsDur(m-1)==lowFreqsDur(m+1) && highFreqsDur(m-1)==highFreqsDur(m+1))
            duration(m-1) = duration(m-1)+duration(m+1);
            lowFreqsDur(m:m+1)  = [];
            highFreqsDur(m:m+1) = [];
            duration(m:m+1) = [];
            m = m-1;
        end
    end 
    m = m+1;
end

% Convert recorded DTMF tones to digits
vec = [];
m = 1; 
while(m <= length(duration)-1)
    if(lowFreqsDur(m)~=0 && highFreqsDur(m)~=0 && duration(m) >= 8)
        vec = [vec,KEYS(lowFreqsDur(m)==FREQS(5:8),highFreqsDur(m)==FREQS(9:12))];
    end
    m = m+1;
end

% Convert string 0123456789 or 10123456789 to phone# format 012-345-6789 or 1-012-345-6789
D = length(vec);
digits = char(zeros(1,D+floor((D-2)/3)));
digits(end-4:-4:1) = '-';
digits(digits~='-') = vec;