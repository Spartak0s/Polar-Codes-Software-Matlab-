file = fopen('bit error rate.txt','w'); %file to save my data results
fprintf(file,'\n\n[%d,%d,%d,%d,%d,%d,%d,%d,%d] \n',[0,0.5,1,1.5,2,2.5,3,3.5,4]);%Other possible SNRdb arrays[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]);
for data = [2,3,4,5,6,7,8,9]            %Code length N=2^data
N = power(2,data);                      %Code Length
K = N/2;                                %Code keyword length
capacity = 0.5;                         %I(W), Channel's W Capacity
frozen_bits = initialize_frozen_bits(N,K,capacity); %0=frozen bit, 1=not_frozen bit
%%
for L = [1,2,4,8]
fprintf(file,'\nN = %d L = %d[', [N,L]);
for SNRdb = [0,0.5,1,1.5,2,2.5,3,3.5,4];%Other possible SNRdb arrays [0,2,4,6,8,10] %[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]
errors = 0;
codewords = 0;
while (errors<1000 && codewords<10)
codewords = codewords + 1;
inputs = randi([0,1],1,K);              %write random inputs
%transform inputs
inputs_to_encode = transform_inputs(inputs,frozen_bits,N);
%encode
encoded_inputs = encode(inputs_to_encode);      %Reversed Polar Encoding (already reversed)
%modulate
modulated_inputs = modulate(encoded_inputs);    %BPSK = 1-2*encoded_inputs(i)
%noise
noised_inputs = add_noise(modulated_inputs,SNRdb);        %awgn noise (0,SNR) SNR in db !!!not s^2
%demodulate
llr = (2 * power(10,SNRdb/10))*noised_inputs;       %CARE NEGATIVE SIGN.2*yi/(s^2) = ln(Li), s^2 = 1/ 10^ (SNRdb/10)
%decode
outputs = list_decode(llr,frozen_bits,L);   %or decode(llr,frozen_bits); decode2(llr,frozen_bits); <---for the other algorithms
%choose A set (not frozen bits)
final_outputs = transform_outputs(outputs,frozen_bits,N);
for i=1:1:K
    if(final_outputs(i) ~= inputs(i))
        errors = errors + 1;
    end
end
end
%printing results to file
error_rate = errors/(codewords*K);
fprintf(file,'%0.8f,',error_rate);
end
fprintf(file,']\n');
end
fprintf(file,'0]\n');
end
%fprintf(file,'SNRmean = %2.5f]\n',SNRmean/20);
fclose(file);
    
