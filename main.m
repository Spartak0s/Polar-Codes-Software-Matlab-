clc;clear;
start_time = clock;
timestamp = [num2str(start_time(1),'%04d') '_' num2str(start_time(2),'%02d') '_' num2str(start_time(3),'%02d') '_' num2str(start_time(4),'%02d') '_' num2str(start_time(5),'%02d') '_' num2str(start_time(6),'%2.0f')];
result_path = './results/';
file = fopen([result_path 'polar_test_' timestamp '.txt'],'w');
addpath('support');
Fading_Channel = 0;     %0: AWGN, 1:Fading Channel
Fading_Independent = 0; %if Fading_Channel = 1
quasi = 0;              % quasi channel
fading_channel = 'TU120';   %custom matlab channel
fix_seed = 1;           %1:fix data, 0:random data
if fix_seed
    rng(sum(100*clock));
else
    rand('seed',123456);
end
for n = 6%[2,3,4,5,6,7,8,9] %N=2^n
N = power(2,n);      %Code Length
K = N/2;      %Code keyword length
capacity = 0.5; %I(W), Channel's W Capacity
frozen_bits = initialize_frozen_bits(N,K,capacity); %0=frozen, 1=not_frozen
%%
fprintf(file,'\n\n[%d,%d,%d,%d,%d,%d]\n',[0,2,4,6,8,10]);%[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]);
fprintf(file,'N = %d\n[', N);
SNRdb_values = 0:5;
for SNRdb = SNRdb_values %[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]
fer_errors = 0;
bit_errors = 0;
codewords = 0;
while (fer_errors<100 || codewords<100)
codewords = codewords + 1;
inputs = randi([0,1],1,K);    %write random inputs
%transform inputs
inputs_to_encode = transform_inputs(inputs,frozen_bits,N);
%encode
encoded_inputs = encode(inputs_to_encode);      %Reversed Polar Encoding
%modulate
modulated_inputs = modulate(encoded_inputs);%encoded_inputs);        %BPSK = 1-2*encoded_inputs(i)
%noise
noised_inputs = add_noise(modulated_inputs,Fading_Channel,Fading_Independent,fading_channel,SNRdb);
%demodulate
llr = (2 * power(10,SNRdb/10))*noised_inputs;       %CARE NEGATIVE SIGN.2*yi/(s^2) = ln(Li), s^2 = 1/ 10^ (SNRdb/10)
%decode
outputs = decode(llr,frozen_bits);
%or decode(llr,frozen_bits); for the other algorithm
%choose A set (not frozen bits)
%Calculate bit/frame errors
final_outputs = transform_outputs(outputs,frozen_bits,N);
temp_bit_errors = size(find(final_outputs ~= inputs),2);
bit_errors = bit_errors + temp_bit_errors;
fer_errors = fer_errors + (temp_bit_errors>0);
end
bit_error_rate = bit_errors/(codewords*K);
frame_error_rate = fer_errors/(codewords);
fprintf(file,'SNRdb = %d\tber=%0.8f,fer=%0.8f\n',SNRdb,bit_error_rate,frame_error_rate);
fprintf('SNRdb = %d\tber=%0.8f,fer=%0.8f\n',SNRdb,bit_error_rate,frame_error_rate);
end
file = fopen([result_path 'results_N=' num2str(N) '_SNR=' num2str(SNRdb_values(1)) '-' num2str(SNRdb_values(end)) '.txt'],'w');
fprintf(file,'0]\n');
end
%fprintf(file,'SNRmean = %2.5f]\n',SNRmean/20);
fclose(file);
    
