function [ Fn,frozen_bits,partial_sum_adders, sc_functions, sc_2nd_indxs] = polar_initialization( N, K, capacity )
%POLAR_INITIALIZATION Summary of this function goes here
%   Detailed explanation goes here
Fn = fkronecker(N);
frozen_bits = initialize_frozen_bits(N,K,capacity); %0=frozen, 1=not_frozen
partial_sum_adders = partial_sums_initialize(N);   %!!!!! NOT bit_reversed array -- %outputs(z,i,l) -- l stage ,bit Ui is added,z is the number of g adder
[sc_functions,sc_2nd_indxs] = sc_array_initialize(N);
end

