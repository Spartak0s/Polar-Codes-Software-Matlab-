function estimated = decode2(llr,frozen_bits)
%takes llr values, frozen bits (0 frozen, 1 unfrozen) and outputs the
%estimated decoded outputs Ui. Using 2 recursive functions l,s.
N = length(llr);
estimated = zeros(1,N);
%llr should be in bit-reversed order
reverse_llr = bitrevorder(llr);
for i=1:1:N
    if(frozen_bits(i) == 1)
        a = l_f(1,i,reverse_llr,frozen_bits,estimated);
        if( a >= 0)
            estimated(i) = 0;
        else
            estimated(i) = 1;
        end
    end
end
end

