%% Setup values for function
f=[697 770 852 941 1209 1336 1477 1633];
% frequencies for numbers 0:9 and A:D on keypad
Fs = 8000; %sampling frequency


%% Bandpass filters


% Get filter object from filter .m files
colb=[0.000474561119910818,-0.000932233615581857,-0.00156209436671309,-0.000341636700127789,0.00207121728146170,0.00242215194425515,-0.000652549872980256,-0.00355739292351486,-0.00193146506265503,0.00257919601483361,0.00353762346416956,-0.000959226510668918,-0.00428498548898116,-0.000476591893912933,0.00562333292727071,0.00389520165718451,-0.00545836273286366,-0.00959314120683476,-0.000550616445080721,0.0113866566908439,0.0100395143605693,-0.00390896676020845,-0.0128091052261311,-0.00626790490162276,0.00513509810658517,0.00674192007862584,0.00112498974559296,0.000837779974680007,0.00517831100343656,0.000570481309550801,-0.0135107047149119,-0.0164708406214938,0.00374359968260207,0.0259204593878627,0.0196644538840887,-0.0104673659665197,-0.0273356774089992,-0.0121464034277484,0.00997418181143102,0.00999590248800685,-0.000368613756226076,0.00792342523858328,0.0243434425873368,0.00620337860411450,-0.0460893762816521,-0.0631552793576237,0.00469954532605029,0.0953769331706719,0.0891444654438989,-0.0328980819254674,-0.137381388363016,-0.0902661856329556,0.0671806029758059,0.153904689375030,0.0671806029758059,-0.0902661856329556,-0.137381388363016,-0.0328980819254674,0.0891444654438989,0.0953769331706719,0.00469954532605029,-0.0631552793576237,-0.0460893762816521,0.00620337860411450,0.0243434425873368,0.00792342523858328,-0.000368613756226076,0.00999590248800685,0.00997418181143102,-0.0121464034277484,-0.0273356774089992,-0.0104673659665197,0.0196644538840887,0.0259204593878627,0.00374359968260207,-0.0164708406214938,-0.0135107047149119,0.000570481309550801,0.00517831100343656,0.000837779974680007,0.00112498974559296,0.00674192007862584,0.00513509810658517,-0.00626790490162276,-0.0128091052261311,-0.00390896676020845,0.0100395143605693,0.0113866566908439,-0.000550616445080721,-0.00959314120683476,-0.00545836273286366,0.00389520165718451,0.00562333292727071,-0.000476591893912933,-0.00428498548898116,-0.000959226510668918,0.00353762346416956,0.00257919601483361,-0.00193146506265503,-0.00355739292351486,-0.000652549872980256,0.00242215194425515,0.00207121728146170,-0.000341636700127789,-0.00156209436671309,-0.000932233615581857,0.000474561119910818;];
rowb=[0.000945787956669407,0.000372595379142179,-0.000414658405181117,-0.00174339905881631,-0.00300754607323483,-0.00327061158896733,-0.00174459191175499,0.00159938897810475,0.00566028615103016,0.00843636687026031,0.00792463567790728,0.00333222891486382,-0.00409318139955560,-0.0112479047364019,-0.0145206320853615,-0.0117269697295376,-0.00355785298609024,0.00643958109070302,0.0135611171174945,0.0145156384247386,0.00937469861323721,0.00160859847386289,-0.00402112306666083,-0.00455527848099008,-0.000966673450745421,0.00224520237542859,7.44279609591604e-05,-0.00904476478078409,-0.0209794496468590,-0.0272426377709717,-0.0197855880924097,0.00322917730447459,0.0342786326660773,0.0585130394018876,0.0607697679939461,0.0342512998693288,-0.0139683348058471,-0.0642865184648740,-0.0929752288069270,-0.0838738927157436,-0.0373832358356305,0.0282866095775546,0.0848287424289370,0.107020087276661,0.0848287424289370,0.0282866095775546,-0.0373832358356305,-0.0838738927157436,-0.0929752288069270,-0.0642865184648740,-0.0139683348058471,0.0342512998693288,0.0607697679939461,0.0585130394018876,0.0342786326660773,0.00322917730447459,-0.0197855880924097,-0.0272426377709717,-0.0209794496468590,-0.00904476478078409,7.44279609591604e-05,0.00224520237542859,-0.000966673450745421,-0.00455527848099008,-0.00402112306666083,0.00160859847386289,0.00937469861323721,0.0145156384247386,0.0135611171174945,0.00643958109070302,-0.00355785298609024,-0.0117269697295376,-0.0145206320853615,-0.0112479047364019,-0.00409318139955560,0.00333222891486382,0.00792463567790728,0.00843636687026031,0.00566028615103016,0.00159938897810475,-0.00174459191175499,-0.00327061158896733,-0.00300754607323483,-0.00174339905881631,-0.000414658405181117,0.000372595379142179,0.000945787956669407;];

% Apply column and row signal to signal
rowFilt=filter(rowb,1,x);
colFilt=filter(colb,1,x);


%% Create Windows
% Desired frequency resolution 73 Hz thus with a rectangular window the
% peak to null resolution is 1/T. To get T >=13.7 ms we need M=110. M=106
% gives 13.3 ms and gives two full windows in 40 ms.
L=106;

% Time to index converstions
t_10ms=round(Fs/L*0.010);
t_23ms=round(Fs/L*0.023);
t_40ms=round(Fs/L*0.040);


%% Goertzel DFT
N_fundamental = 205; %Number of points for DFT of fundamentals
N_harmonics = 201; %Number of points for DFT of harmonics

% Indices of the DFT for the frequencies f 
freq_indices = round(f/Fs*N_fundamental)+1;
harmonic_indicies = round(f*2/Fs*N_harmonics)+1;

% Calculate number of windows in sample with given window size
nWindows=floor(length(x)/L)-1;

dft_col=zeros(nWindows,4);
dft_col_harmonic=zeros(nWindows,4);
dft_row=zeros(nWindows,4);
dft_row_harmonic=zeros(nWindows,4);
for n=1:nWindows
    %Compute DFT of fundamentals using Goertzel algorithm
    padded_col=[colFilt(n*L:(n+1)*L),zeros(1,N_fundamental-L)];
    padded_row=[rowFilt(n*L:(n+1)*L),zeros(1,N_fundamental-L)];
    dft_col(n,:) = goertzel(padded_col,freq_indices(5:end));
    dft_row(n,:) = goertzel(padded_row,freq_indices(1:4));
    
    %Compute DFT of harmonics using Goertzel algorithm
    padded_col_harmonics=[colFilt(n*L:(n+1)*L),zeros(1,N_harmonics-L)];
    padded_row_harmonics=[rowFilt(n*L:(n+1)*L),zeros(1,N_harmonics-L)];
    dft_col_harmonic(n,:) = goertzel(padded_col_harmonics,harmonic_indicies(5:end));
    dft_row_harmonic(n,:) = goertzel(padded_row_harmonics,harmonic_indicies(1:4));
end


%% Calculate Signal Power

% Compute average power
% Take the magnitude of dft of x and scale the dft so that it is not a 
% function of the window length

col_power = abs(dft_col)/L; 
col_harmonic_power = abs(dft_col_harmonic)/L; 
row_power = abs(dft_row)/L; 
row_harmonic_power = abs(dft_row_harmonic)/L;

% Take the square of the magnitude of dft of windowed x. 

col_power = col_power.^2; 
col_harmonic_power = col_harmonic_power.^2;
row_power = row_power.^2;
row_harmonic_power = row_harmonic_power.^2;

% We multiply mx by 2 to keep the same energy as the symetric dft.
% The DC component and Nyquist component, if it exists, are unique
% and should not be multiplied by 2.

if rem(N_fundamental, 2) % odd dft excludes Nyquist point
  col_power(2:end) = col_power(2:end)*2;
  col_harmonic_power(2:end) = col_harmonic_power(2:end)*2;
  row_power(2:end) = row_power(2:end)*2;
  row_harmonic_power(2:end) = row_harmonic_power(2:end)*2;
else
  col_power(2:end -1) = col_power(2:end -1)*2;
  col_harmonic_power(2:end-1) = col_harmonic_power(2:end-1)*2;
  row_power(2:end -1) = row_power(2:end -1)*2;
  row_harmonic_power(2:end-1) = row_harmonic_power(2:end-1)*2;
end


% Calculate average power for row freqs and column freqs.
avg_col_power = mean(col_power,2); 
avg_row_power = mean(row_power,2); 

% Calculate max power for row freqs and column freqs.
[max_col_power,max_col_power_index] = max(col_power,[],2); 
[max_row_power,max_row_power_index] = max(row_power,[],2);

% Calculate ratio of max power to avg power for row freqs and column freqs.
ratio_col_power = max_col_power./avg_col_power;
ratio_row_power = max_row_power./avg_row_power;

%% Logic to determine if it is a key press
power_ratio_thresh=2;
harmonic_ratio_thresh=2;
power_thresh=10e-3;

% Set all guesses to -1 to indicate that a frequency was not detected in
% that window
col_freq_guess=ones(nWindows,1)*-1;
row_freq_guess=ones(nWindows,1)*-1;

for n=1:nWindows
    ratio_test=ratio_col_power(n,1)>power_ratio_thresh &&...
            ratio_row_power(n,1)>power_ratio_thresh;
        
    threshold_test=max_col_power(n,1)>power_thresh &&...
            max_row_power(n,1)>power_thresh;
        
    if (ratio_test && threshold_test)
        % Calculate ratio of 2nd harmonic to fundamental to check for voice
        col_harmonic_ratio=col_harmonic_power(n,max_col_power_index(n,1))/col_power(n,max_col_power_index(n,1));
        row_harmonic_ratio=row_harmonic_power(n,max_row_power_index(n,1))/row_power(n,max_row_power_index(n,1));
        if (col_harmonic_ratio<harmonic_ratio_thresh && row_harmonic_ratio<harmonic_ratio_thresh)
            col_freq_guess(n,1)=max_col_power_index(n,1);
            row_freq_guess(n,1)=max_row_power_index(n,1);
        end
    end
end

%% Key Press Logic

keys = ['1','2','3','A'; 
        '4','5','6','B';
        '7','8','9','C';
        '*','0','#','D']; 

% Initialize counters
signal_counter=0;  
silence_counter=0;
digits=[];
col_guess=[];
row_guess=[];
for n=1:nWindows
    
    % Test if there is a pair of freqs
    isKey=col_freq_guess(n)>0 && row_freq_guess(n)>0;
    
    % If a key is pressed, test duration rules
    switch isKey
        case true
            col_guess=[col_guess col_freq_guess(n)]; %Index of guessed col
            row_guess=[row_guess row_freq_guess(n)]; %Index of guessed row
            % Check if previous signal was interrupted for >10ms.
            if(silence_counter>t_10ms)  
                % Check if previous signal was at least 23ms
                if(signal_counter>t_23ms)
                    % Find the mode of the previous guesses to account for
                    % any anomalous frequency pairs
                    key_col=mode(col_guess);
                    key_row=mode(row_guess);
                    % Add digit to digits string
                    digits=[digits keys(key_row,key_col)];
                end
                signal_counter=1; % Start new signal counter
                silence_counter=0; % Reset silence_counter
                col_guess=[]; % Reset column guesses
                row_guess=[]; % Reset row guesses
            else
                % Since interruption was <10ms, assume signal is continuing
                signal_counter=signal_counter+1; % Increment signal counter
                silence_counter=0; % Reset silence_counter
            end
        case false
            silence_counter=silence_counter+1; % Increment silence counter
    end
end

% Check if an additional digit was registers if last window contained a
% signal
if(signal_counter>t_23ms)
    key_col=mode(col_guess);
    key_row=mode(row_guess);
    digits=[digits keys(key_row,key_col)];
end
