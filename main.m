clc;clear;
start_time = clock;
config;
for n = [7,8,9,10] %N=2^n
N = power(2,n);      %Code Length
K = N* code_rate;      %Code keyword length
mat_file = [result_path 'polar_N' num2str(N) '_K' num2str(K) '_' timestamp '.mat'];
bit_error_rate = zeros(1,length(snrdb_values));
fer_error_rate = zeros(1,length(snrdb_values));
codewords = zeros(1,length(snrdb_values));
%Polar-code initializations
Fn = fkronecker(N);
frozen_bits = initialize_frozen_bits(N,K,capacity); %0=frozen, 1=not_frozen
partial_sum_adders = partial_sums_initialize(N);   %!!!!! NOT bit_reversed array -- %outputs(z,i,l) -- l stage ,bit Ui is added,z is the number of g adder
[sc_functions,sc_2nd_indxs] = sc_array_initialize(N);
for i_index = 1:length(snrdb_values) %[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]
%Initialize temporary variables
codewords_tmp = 0;
fer_errors = 0;
bit_errors = 0;
snr = snrdb_values(i_index);
while (fer_errors<min_fer_errors || codewords_tmp<min_codewords)
codewords_tmp = codewords_tmp + 1;
inputs = rand(1,K)>0.5;    %write random inputs
%transform inputs
inputs_to_encode = transform_inputs(inputs,frozen_bits,N);
%encode
encoded_inputs = encode(inputs_to_encode,Fn);      %Reversed Polar Encoding
%modulate
modulated_inputs = modulate(encoded_inputs);%encoded_inputs);        %BPSK = 1-2*encoded_inputs(i)
%noise
noised_inputs = add_noise(modulated_inputs,constDims,Fading_Channel,Fading_Independent,fading_channel,snrdb_values(i_index));
%demodulate
llr = (2 * power(10,snrdb_values(i_index)/10))*noised_inputs;       %CARE NEGATIVE SIGN.2*yi/(s^2) = ln(Li), s^2 = 1/ 10^ (SNRdb/10)
%decode
if(fast_run)
    %optimal version (optimal-calculations of f/g)
    outputs = decode2(llr,frozen_bits);
else
    %hardware-version (suboptimal-calculations of f/g)
    outputs = decode(llr,frozen_bits,partial_sum_adders,sc_functions,sc_2nd_indxs);
end
%or decode(llr,frozen_bits); for the other algorithm
%choose A set (not frozen bits)
%Calculate bit/frame errors
final_outputs = transform_outputs(outputs,frozen_bits,N);
temp_bit_errors = size(find(final_outputs ~= inputs),2);
bit_errors = bit_errors + temp_bit_errors;
fer_errors = fer_errors + (temp_bit_errors>0);
end
bit_error_rate(i_index) = bit_errors/(codewords_tmp*K);
fer_error_rate(i_index) = fer_errors/(codewords_tmp);
codewords(i_index) = codewords_tmp;
save(mat_file,'snrdb_values','bit_error_rate','fer_error_rate','codewords','N','K');
fprintf('SNRdb = %d\tber=%0.8f,fer=%0.8f\n',snrdb_values(i_index),bit_error_rate(i_index),fer_error_rate(i_index));
end
% file = fopen([result_path 'results_N=' num2str(N) '_SNR=' num2str(snrdb_values(1)) '-' num2str(snrdb_values(end)) '.txt'],'w');
% fprintf(file,'0]\n');
end
    
