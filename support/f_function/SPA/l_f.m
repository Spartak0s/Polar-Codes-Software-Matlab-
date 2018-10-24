function output = l_f(l,j,llr,frozen_bits,estimated)
%Takes l (stage from 1 to log2(N)+1), j-channel (from 1 to N), llr array, frozen
%bits array and current estimated outputs array
%outputs the l
%Sum-Product Algorithm (SPA) deployed
stages = log2(length(frozen_bits));
if (l == stages+1)
    output = llr(j);
elseif( mod(floor((j-1)/power(2,l-1)),2) == 0)
    output = 2*atanh(tanh(l_f(l+1,j,llr,frozen_bits,estimated)/2) * tanh(l_f(l+1,j+power(2,l-1),llr,frozen_bits,estimated)/2));
else
    output = (1-2*s_f(l,j-power(2,l-1),frozen_bits,estimated)) * (l_f(l+1,j-power(2,l-1),llr,frozen_bits,estimated)) + l_f(l+1,j,llr,frozen_bits,estimated) ;
end

%correct