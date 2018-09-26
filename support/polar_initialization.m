function [ Fn,frozen_bits, frozen_indxs, non_frozen_indxs, partial_sum_adders, sc_functions, sc_2nd_indxs] = polar_initialization( N, K, capacity )
%POLAR_INITIALIZATION Summary of this function goes here
%   Detailed explanation goes here
Fn = fkronecker(N);
frozen_bits = initialize_frozen_bits(N,K,capacity); %0=frozen, 1=not_frozen
frozen_indxs = find(frozen_bits == 0);
non_frozen_indxs = find(frozen_bits == 1);
partial_sum_adders = partial_sums_initialize(N);   %!!!!! NOT bit_reversed array -- %outputs(z,i,l) -- l stage ,bit Ui is added,z is the number of g adder
[sc_functions,sc_2nd_indxs] = sc_array_initialize(N);
end

