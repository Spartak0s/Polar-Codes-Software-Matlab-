function outputs = transform_inputs(inputs,frozen_bits,N)
%takes Xi inputs,the position of frozen bits, and makes the outputs array
%inputs at not frozen positions, 0 at frozen positions
outputs = zeros(1,N);
index = 1;
for i=1:1:N
    if(frozen_bits(i) == 1) %1 = data, 0 = frozen
        outputs(i) = inputs(index);
        index = index +1;
    end
end

% correct

