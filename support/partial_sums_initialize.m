function outputs = partial_sums_initialize(N)        %!!!! care outputs are mapped to 0-->7 adders
outputs = zeros(N/2,N,log2(N));        %outputs(z,i,l) -- l stage ,bit Ui is added,z is the number of g adder
for l=0:1:log2(N)-1
    for z=0:1:N/2-1
        for i=0:1:N-1
            temp1 = 1;
            for u=l:1:log2(N)-2
                temp1=and(not(xor(b(log2(N)-u-2,z),b(u+1,i))),temp1);
            end
            temp2=1;
            for w=0:1:l-1
                temp2=and(or(not(b(log2(N)-w-2,z)),b(w,i)),temp2);
            end
            outputs(z+1,i+1,l+1) = temp1*temp2* not(b(l,i));
        end        
    end
end
end

