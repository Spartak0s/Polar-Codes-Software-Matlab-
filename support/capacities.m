function capacities = capacities( N, capacity)
%Estimates the capacities of all channels
%Outputs array with the capacities of the N channels
bits = log2(N);
capacities = ones(1,N)*capacity;
for j=0:1:bits-1
    step = power(2,j);
    for i=1:2*step:power(2,bits)
        for z=i:1:i+step-1
            temp = capacities(z) * capacities(z);
            capacities(z+step) = 2*capacities(z+step) - temp;
            capacities(z)= temp;
        end
    end
end
    

end

