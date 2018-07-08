function frozen_bits = initialize_frozen_bits( N, K, capacity )
    %inputs N codelength, K code keyword length, capacity of the channel
    %outputs a N-length array with 0,1. If 0 then the channel is frozen
    %if 1 not frozen.
    %calculate capacities and reverse them (reverse-encode)
    capacity_array = bitrevorder(capacities(N, capacity));
    [~,sortIndex] = sort(capacity_array(:));
    %freeze N-K worst-channels and keep K best-channels
    frozen_bits = ones(1,N);
    frozen_bits(sortIndex(1:N-K)) = 0;
end