function [sc_function,sc_2nd_indxs] = sc_array_initialize(bits)
%decoding initialization
outputs = zeros(bits,log2(bits)+1,3);%outputs(i-1,l-1,dimension) // dimension= 1 values/dimension=2 if 0 then f else g/dimension=3 2nd input
sc_function = zeros(bits,log2(bits)+1);
sc_2nd_indxs = zeros(bits,log2(bits)+1);
reverse_i = bitrevorder(1:1:bits);
%f-g function array
for l=1:1:log2(bits) %array l, l=stages from right to left ( N+1->1 or N->1 )??
    butterfly = [zeros(1,bits/pow2(l)) ones(1,bits/pow2(l))].';
    factor = (bits/pow2(l));
    second_index = [ones(1,bits/pow2(l))*(factor) ones(1,bits/pow2(l))*(-factor)].';
    sc_function(:,l) = repmat(butterfly,[pow2(l-1),1]);
    sc_2nd_indxs(:,l) = repmat(second_index,[pow2(l-1),1]);
end
end

% correct initialization checked.