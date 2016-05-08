function outputs = sc_array_initialize(bits,llr_inputs)
%decoding initialization
outputs = zeros(bits,log2(bits)+1,3);%outputs(i-1,l-1,dimension) // dimension= 1 values/dimension=2 if 0 then f else g/dimension=3 2nd input
reverse_i = bitrevorder(1:1:bits);
for l=1:1:log2(bits)+1 %array l, l=stages from right to left ( N+1->1 or N->1 )??
    if(l ~= log2(bits)+1)
        for i = 1:1:bits        %array i, i=1 to N
            outputs(reverse_i(i),l,2) = floor(mod((i-1)/power(2,l-1),2));    %i-1 and l-1 with paper notation // care floor
            outputs(reverse_i(i),l,3) = power(-1,outputs(reverse_i(i),l,2))* bits / power(2,l); %i-1 and l-1 with paper notation
        end
    else
        for i = 1:1:bits        %array i
            outputs(i,l,1) = llr_inputs(i);     %already reversed llrs
        end
    end
end
end

% correct initialization checked.