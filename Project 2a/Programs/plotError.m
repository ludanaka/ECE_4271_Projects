SNRdB = -2:1:8;

zz = 10.^(SNRdB./10);
uu = sqrt(2*zz);
QQ = (exp((-uu.^2)/2)./(uu*sqrt(2*pi)));

% semilogy(SNRdB, QQ, 'b')
% title('BER vs. SNR for Theoretical and Simulation Binary Case')
% xlabel('SNR (dB)')
% ylabel('Bit Error Rate')
BPSK = [];
for s = SNRdB
    BPSK = [BPSK transceiver(1e4, s, 2)];
end
% hold on
% semilogy(SNRdB, BPSK, 'r')
% legend('Theoretical', 'Simulation')


% QAM4 = [];
% for s = SNRdB
%     QAM4 = [QAM4 transceiver(1e4, s, 4)];
% end
% semilogy(SNRdB, QAM4);
% xlabel('SNR (dB)')
% ylabel('Bit Error Rate')
% title('BER vs. SNR for 4QAM')

% QAM16 = [];
% for s = SNRdB
%     QAM16 = [QAM16 transceiver(1e4, s, 16)];
% end
% semilogy(SNRdB, QAM16);
% xlabel('SNR (dB)')
% ylabel('Bit Error Rate')
% title('BER vs. SNR for 16QAM')