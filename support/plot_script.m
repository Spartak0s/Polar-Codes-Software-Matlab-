% % draw the BER vs Eb/N0 plot
if(Fading_Channel)
    channel_str = 'Fading';
else
    channel_str = 'AWGN';
end
figure(1)
semilogy(EbNo_dB(1:length(find(bit_error_rate(index_n,:) ~= 0))), bit_error_rate(:,1:length(find(bit_error_rate(index_n,:) ~= 0))),'LineWidth', 2, 'MarkerSize',10);
% axis([EbNo_dB(1) EbNo_dB(length(find(BER_list_1 ~= 0))) min(min(BER_list_1((BER_list_1 ~= 0))),min(BER_list_2((BER_list_2 ~= 0)))) max(max(BER_list_2((BER_list_1 ~= 0))),max(BER_list_1((BER_list_2 ~= 0))))])
hold on;
xlabel('Eb/N0 [dB]');
ylabel('BER');

title(['Polar codes ,' channel_str]);
if(index_n == length(legends))
    legend(legends,'Location','SouthWest');
end
grid on;
% % draw the FER vs Eb/N0 plot
figure(2)
semilogy(EbNo_dB(1:length(find(fer_error_rate(index_n,:) ~= 0))), fer_error_rate(:,1:length(find(fer_error_rate(index_n,:) ~= 0))),'LineWidth', 2, 'MarkerSize',10);
% axis([EbNo_dB(1) EbNo_dB(length(find(FER_list_1 ~= 0))) min(min(FER_list_1((FER_list_1 ~= 0))),min(FER_list_2((FER_list_2 ~= 0)))) max(max(FER_list_2((FER_list_1 ~= 0))),max(FER_list_1((FER_list_2 ~= 0))))])
hold on;
xlabel('Eb/N0 [dB]');
ylabel('FER');
title(['Polar codes ,' channel_str]);
if(index_n == length(legends))
    legend(legends,'Location','SouthWest');
end
grid on;