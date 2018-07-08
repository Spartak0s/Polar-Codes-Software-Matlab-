function outputs = encode(inputs,Fn)
%outputs = x where x= u * G , where G = B(N) * Fn
%basic encoding scheme with kronecker power of Fn.
outputs = mod(bitrevorder(inputs) * Fn,2); %Reversed outputs
end


%correct