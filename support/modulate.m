function outputs = modulate(encoded_inputs)
%takes encoded inputs array, and outputs modulated BPSK signal
bits = length(encoded_inputs);
outputs = zeros(1,bits);
for i=1:1:bits
outputs(i) = 1-encoded_inputs(i)*2;
end

%correct