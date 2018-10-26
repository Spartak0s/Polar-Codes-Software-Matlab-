clc;clear all;
start_time = clock;
config;
%% N LOOP
for index_n = 1:length(n_values)                    %N=2^n
    N = power(2,n_values(index_n));                 %Code Length
    K = N* code_rate;                               %Code keyword length
    mat_file = [result_path 'polar_N' num2str(N) '_K' num2str(K) '_' timestamp '.mat'];
    %Polar-code initializations
    [Fn,frozen_bits, frozen_indxs, non_frozen_indxs, partial_sum_adders, sc_functions, sc_2nd_indxs] = polar_initialization(N, K, capacity);
    fprintf("Polar Code %d/%d running:\n",N,K);
    %% SNR LOOP
    for i_index = 1:length(snrdb_values)
        %Initialize temporary variables
        codewords_tmp = 0;fer_errors = 0;bit_errors = 0;
        snr = snrdb_values(i_index);
        while (fer_errors<min_fer_errors || codewords_tmp<min_codewords)
            bit_errors_parfor = zeros(1,parallel_frames);
            fer_errors_parfor = zeros(1,parallel_frames);
            for frame = 1:parallel_frames
%             parfor frame = 1:parallel_frames
            inputs = rand(1,K)>0.5;    %write random inputs
            %transform inputs
            inputs_to_encode = transform_inputs(inputs,non_frozen_indxs,N);
            %encode
            encoded_inputs = encode(inputs_to_encode,Fn);      %Reversed Polar Encoding
            %modulate
            modulated_inputs = modulate(encoded_inputs);%encoded_inputs);        %BPSK = 1-2*encoded_inputs(i)
            %noise
            noised_inputs = add_noise(modulated_inputs,constDims,Fading_Channel,Fading_Independent,fading_channel,snrdb_values(i_index));
            %demodulate
            llr = (2 * power(10,snrdb_values(i_index)/10))*noised_inputs;       %CARE NEGATIVE SIGN.2*yi/(s^2) = ln(Li), s^2 = 1/ 10^ (SNRdb/10)
            %decode
            if(sc_decoding)
                if(fast_run)
                    %optimal version (optimal-calculations of f/g)
                    outputs = decode2(llr,frozen_bits);
                else
                    %hardware-version (suboptimal-calculations of f/g)
                    outputs = decode(llr,frozen_bits,partial_sum_adders,sc_functions,sc_2nd_indxs); %or decode2(llr,frozen_bits); for the other algorithm
                end
            else
                iterations = 50;
                outputs = bp_decode(llr,frozen_bits,sc_functions,sc_2nd_indxs,iterations); %or decode2(llr,frozen_bits); for the other algorithm
            end
            final_outputs = outputs(non_frozen_indxs);%transform_outputs(outputs,frozen_bits,N);
            %Calculate temporary bit/frame errors
            temp_bit_errors = sum(final_outputs ~= inputs);
            bit_errors_parfor(frame) = temp_bit_errors;
            fer_errors_parfor(frame) = (temp_bit_errors>0);
            end
            codewords_tmp = codewords_tmp + parallel_frames;
            bit_errors = bit_errors + sum(bit_errors_parfor);
            fer_errors = fer_errors + sum(fer_errors_parfor);
        end
        %Calculate snr bit/frame errors
        bit_error_rate(index_n,i_index) = bit_errors/(codewords_tmp*K);
        fer_error_rate(index_n,i_index) = fer_errors/(codewords_tmp);
        codewords(index_n,i_index) = codewords_tmp;
        legends(index_n) = [num2str(N), '/', num2str(K)];
        %Update plot figures
        %Save results for particular n & snr
        save(mat_file,'snrdb_values','EbNo_dB','bit_error_rate','fer_error_rate','codewords','N','K','Fading_Channel','Fading_Independent','fading_channel');
        %Display
        fprintf('EbNo = %.1f\tber=%0.5f,fer=%0.5f\n',EbNo_dB(i_index),bit_error_rate(index_n,i_index),fer_error_rate(index_n,i_index));
    end
    % file = fopen([result_path 'results_N=' num2str(N) '_SNR=' num2str(snrdb_values(1)) '-' num2str(snrdb_values(end)) '.txt'],'w');
end
plot_script;
