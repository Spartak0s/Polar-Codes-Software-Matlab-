function frozen_bits = initialize_frozen_bits( N, K, capacity )
    %inputs N codelength, K code keyword length, capacity of the channel
    %outputs a N-length array with 0,1. If 0 then the channel is frozen
    %if 1 not frozen.
    capacity_array = bitrevorder(capacities(N, capacity));
    [capacity_array,sortIndex] = sort(capacity_array(:));
    frozen_bits = ones(1,N);
    for i=1:1:N-K
        frozen_bits(sortIndex(i)) = 0;
    end
        
end