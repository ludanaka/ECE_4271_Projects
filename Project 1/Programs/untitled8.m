Fs = 8000;
Wp = [650/Fs 1000/Fs];
Ws = [100/Fs 1500/Fs];
Rp = 20*log10(1.005);
Rs = 40;
ww = 0:pi/8000:pi;

[Ne, Wpe] = ellipord(Wp, Ws, Rp, Rs);
[B, A] = ellip(Ne, Rp, Rs, Wpe);
freqz(B,A,ww)