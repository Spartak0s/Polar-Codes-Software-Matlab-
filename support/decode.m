function outputs = decode(llr_inputs,frozen_bits,partial_sum_adders,sc_functions,sc_2nd_indxs)
bits = length(llr_inputs);
reverse_order = bitrevorder(1:1:bits); %same as 0:1:bits-1
sc_array = zeros(bits,log2(bits)+1);
sc_array(:,log2(bits)+1) = llr_inputs.';
outputs = zeros(1,bits);        %NOT bit_reversed_array
non_frozen_indxs = find(frozen_bits == 1);
for bit=non_frozen_indxs %Arikan 0:1:bits-1
    for l= log2(bits):-1:1 %Arikan log2(bits)-1:-1:0 
        partial_sums_l = partial_sum_adders(:,:,l) * (transpose(outputs)); %NOT bit_reversed_array
        partial_sums_l = mod(partial_sums_l,2);     %mod 2
        z = 0;      %number of partial sum
        for i = 1:1:bits
            if(sc_functions(i,l) == 0)
                sc_array(i,l,1) = f(sc_array(i+sc_2nd_indxs(i,l),l+1,1),sc_array(i,l+1,1));       %getting values from l+1 stage
            else
                z = z+1;    %the number of adder
                sc_array(i,l,1) = g(sc_array(i+sc_2nd_indxs(i,l),l+1,1),sc_array(i,l+1,1),partial_sums_l(z));     %getting values from l+1 stage + partial_sum
            end
        end
    end
    if(sc_array(reverse_order(bit),1,1)<0)       %if it's not frozen bit, update value
        outputs(bit)=1;
    end
end
end