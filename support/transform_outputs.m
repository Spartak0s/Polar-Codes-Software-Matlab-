function final_outputs = transform_outputs(outputs,frozen_bits,N)
%Inputs the estimated u plus frozen bits and splits them
%Outputs estimated u:outputs without the frozen bits
final_outputs_index = 1;
length = sum(frozen_bits);
final_outputs = zeros(1,length);
for i=1:1:N
    if(frozen_bits(i) == 1) %1 = data, 0 = frozen
        final_outputs(final_outputs_index) = outputs(i);
        final_outputs_index = final_outputs_index + 1;
    end
end

% correct
