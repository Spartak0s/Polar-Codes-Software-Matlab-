file = fopen('ber.txt','w');
fprintf(file,'\n\n[%d,%d,%d,%d,%d,%d,%d,%d,%d] \n',[0,0.5,1,1.5,2,2.5,3,3.5,4]);%[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]);
for data = [5,6,7,8,9,10] %Code Length N=2^data
N = power(2,data);      %Code Length
crc = hexToBinaryVector('D5');  % CRC-8
crc_len = 8; %CRC length
K = N/2;      %Code keyword length
capacity = 0.5; %I(W), Channel's W Capacity
frozen_bits = initialize_frozen_bits(N,K,capacity); %0=frozen, 1=not_frozen
%%
for L = [2,4,8]
fprintf(file,'\nN = %d L = %d[', [N,L]);
for SNRdb = [0,0.5,1,1.5,2,2.5,3];%[0,2,4,6,8,10] %[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]
errors = 0;
codewords = 0;
while (errors<1000 && codewords<200)
codewords = codewords + 1;
inputs = zeros(1,K);
inputs(1:K-crc_len) = randi([0,1],1,K-crc_len);    %write random inputs
inputs(K-crc_len+1:K) = crcInput(inputs(1:K-crc_len),crc,crc_len);
%transform inputs
inputs_to_encode = transform_inputs(inputs,frozen_bits,N);
%encode
encoded_inputs = encode(inputs_to_encode);      %Reversed Polar Encoding
%modulate
modulated_inputs = modulate(encoded_inputs);%encoded_inputs);        %BPSK = 1-2*encoded_inputs(i)
%noise
noised_inputs = add_noise(modulated_inputs,SNRdb);        %awgn noise (0,SNR) SNR in db !!!not s^2
%demodulate
llr = (2 * power(10,SNRdb/10))*noised_inputs;       %CARE NEGATIVE SIGN.2*yi/(s^2) = ln(Li), s^2 = 1/ 10^ (SNRdb/10)
%decode
outputs = list_decode(llr,frozen_bits,L,crc,crc_len);
%or decode(llr,frozen_bits); for the other algorithm
%choose A set (not frozen bits)
final_outputs = transform_outputs(outputs,frozen_bits,N);
for i=1:1:K-crc_len
    if(final_outputs(i) ~= inputs(i))
        errors = errors + 1;
    end
end
error_rate = errors/(codewords*K)
end
error_rate = errors/(codewords*K);
fprintf(file,'%0.8f,',error_rate);
end
fprintf(file,']\n');
end
fprintf(file,'0]\n');
end
%fprintf(file,'SNRmean = %2.5f]\n',SNRmean/20);
fclose(file);
    
