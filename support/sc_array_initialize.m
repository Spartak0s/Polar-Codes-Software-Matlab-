function [sc_function,sc_2nd_indxs] = sc_array_initialize(bits)
%decoding initialization
%sc_function:if 0 then f else g
%sc_2nd_indxs: index of 2nd input
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