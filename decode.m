function outputs = decode(llr_inputs,frozen_bits)
bits = length(llr_inputs);
reverse_order = bitrevorder(1:1:bits); %same as 0:1:bits-1
sc_array = sc_array_initialize(bits,llr_inputs);%--BIT_REVERSED ARRAY-- outputs(i,l,dimension) // dimension= 1 values -- 2 !! if 0 then f else g !!-- 3 2nd input
partial_sum_adders = partial_sums_initialize(bits);   %!!!!! NOT bit_reversed array -- %outputs(z,i,l) -- l stage ,bit Ui is added,z is the number of g adder
outputs = zeros(1,bits);        %NOT bit_reversed_array
for bit=1:1:bits %Arikan 0:1:bits-1
    for l= log2(bits):-1:1 %Arikan log2(bits)-1:-1:0 
        partial_sums_l = partial_sum_adders(:,:,l) * (transpose(outputs)); %NOT bit_reversed_array
        partial_sums_l = mod(partial_sums_l,2);     %mod 2
        z = 0;      %number of partial sum
        for i = 1:1:bits
            if(sc_array(i,l,2) == 0)
                sc_array(i,l,1) = f(sc_array(i+sc_array(i,l,3),l+1,1),sc_array(i,l+1,1));       %getting values from l+1 stage
            else
                z = z+1;    %the number of adder
                sc_array(i,l,1) = g(sc_array(i+sc_array(i,l,3),l+1,1),sc_array(i,l+1,1),partial_sums_l(z));     %getting values from l+1 stage + partial_sum
            end
        end
    end
    if(sc_array(reverse_order(bit),1,1)<0 && frozen_bits(bit)==1)       %if it's not frozen bit, update value
        outputs(bit)=1;
    end
end
end