function [llr_array] = decode3(llr_inputs,llr_array,outputs,partial_sum_adders,sc_array,reverse_order,N,threads,i)
for thread=1:1:threads %L threads
    sc_array(:,log2(N)+1,1) = transpose(llr_inputs);   %MAYBE HERE MISTAKE already reversed llrs
    for l= log2(N):-1:1 %Arikan log2(N)-1:-1:0 
        partial_sums_l = partial_sum_adders(:,:,l) * (transpose(outputs(thread,:))); %NOT bit_reversed_array
        partial_sums_l = mod(partial_sums_l,2); %mod 2
        z = 0;      %number of partial sum
        for i = 1:1:N
            if(sc_array(i,l,2) == 0)
                sc_array(i,l,1) = f(sc_array(i+sc_array(i,l,3),l+1,1),sc_array(i,l+1,1));       %getting values from l+1 stage
            else
                z = z+1;    %the number of adder
                sc_array(i,l,1) = g(sc_array(i+sc_array(i,l,3),l+1,1),sc_array(i,l+1,1),partial_sums_l(z));     %getting values from l+1 stage + partial_sum
            end
        end
    end
    llr_array(:,thread) = bitrevorder(sc_array(:,1,1));
    %if(sc_array(reverse_order(i),1,1)<0 && frozen_bits(i)==1) %if it's not frozen bit, update value
    %    outputs(thread,i)=1;
    %end
end