function output = s_f(l,j,frozen_bits,estimated)
%Takes l (stage from 1 to log2(N)+1), j-channel (from 1 to N), frozen
%bits array and current estimated outputs array
%outputs the estimated s
if (l ==1)
    if( frozen_bits(j) == 0) % or reverse_order(j) may be a solution?
        output = 0;
    else
        output = estimated(j);
    end
else
    if (mod(floor((j-1)/power(2,l-2)),2) == 0)
        output = double(xor(s_f(l-1,j,frozen_bits,estimated),s_f(l-1,j+power(2,l-2),frozen_bits,estimated)));
    else
        output = s_f(l-1,j,frozen_bits,estimated);
    end
end

end

%correct