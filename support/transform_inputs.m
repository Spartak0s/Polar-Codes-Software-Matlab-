function outputs = transform_inputs(inputs,non_frozen_indxs,N)
%takes Xi inputs,the position of frozen bits, and makes the outputs array
%inputs at not frozen positions, 0 at frozen positions
outputs = zeros(1,N);
outputs(non_frozen_indxs) = inputs;
% correct

