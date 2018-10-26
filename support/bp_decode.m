function outputs = bp_decode(llr_inputs,frozen_bits,sc_functions,sc_2nd_indxs,iterations)
non_frozen_indxs = find(frozen_bits == 1);
frozen_indxs = find(frozen_bits == 0);
bits = length(llr_inputs);
reverse_order = bitrevorder(1:1:bits); %same as 0:1:bits-1
L_messages = zeros(bits,log2(bits)+1);
R_messages = zeros(bits,log2(bits)+1);
%% Iteration 1
L_messages(:,log2(bits)+1) = llr_inputs.';
R_messages(reverse_order(frozen_indxs),1) = -1000;
%% <--: right to left pass
for l= log2(bits):-1:1 %Arikan log2(bits)-1:-1:0 
    for i = 1:1:bits
        if(sc_functions(i,l) == 0)
            %f-function
%                 fprintf("f:L(%d,%d,%d)L(%d,%d,%d)R(%d,%d,%d)\n",i+sc_2nd_indxs(i,l),l+1,1,i,l+1,1,i+sc_2nd_indxs(i,l),l,1);
            L_messages(i,l,1) = bp_f(L_messages(i+sc_2nd_indxs(i,l),l+1,1),L_messages(i,l+1,1),R_messages(i+sc_2nd_indxs(i,l),l,1));       %getting values from l+1 stage
        else
            %g-function
%                 fprintf("g:L(%d,%d,%d)L(%d,%d,%d)R(%d,%d,%d)\n",i+sc_2nd_indxs(i,l),l+1,1,i,l+1,1,i+sc_2nd_indxs(i,l),l,1);
            L_messages(i,l,1) = bp_g(L_messages(i+sc_2nd_indxs(i,l),l+1,1),L_messages(i,l+1,1),R_messages(i+sc_2nd_indxs(i,l),l,1));     %getting values from l+1 stage + partial_sum
        end
    end
end
R_messages(reverse_order(non_frozen_indxs),1) = L_messages(reverse_order(non_frozen_indxs),1);
iteration = 1;
while(iteration < iterations)
    iteration = iteration + 1;    
    L_messages(:,log2(bits)+1) = llr_inputs.'+R_messages(:,log2(bits)+1);
    R_messages(reverse_order(frozen_indxs),1) = -1000;
    outputs = zeros(1,bits);        %NOT bit_reversed_array
    %% -->: left to right pass
    for l= 1:1:log2(bits)
        for i = 1:1:bits
            if(sc_functions(i,l) == 0)
                %f-function
%                 fprintf("f:R(%d,%d)R(%d,%d)L(%d,%d)\n",i+sc_2nd_indxs(i,l),l,i,l,i+sc_2nd_indxs(i,l),l+1);
                R_messages(i,l+1,1) = bp_f(R_messages(i+sc_2nd_indxs(i,l),l),R_messages(i,l),L_messages(i+sc_2nd_indxs(i,l),l+1));       %getting values from l+1 stage
            else
                %g-function
%                 fprintf("g:R(%d,%d)R(%d,%d)L(%d,%d)\n",i+sc_2nd_indxs(i,l),l,i,l,i+sc_2nd_indxs(i,l),l+1);
                R_messages(i,l+1,1) = bp_g(R_messages(i+sc_2nd_indxs(i,l),l),R_messages(i,l),L_messages(i+sc_2nd_indxs(i,l),l+1));     %getting values from l+1 stage + partial_sum
            end
        end
    end
    %% <--: right to left pass
    for l= log2(bits):-1:1 %Arikan log2(bits)-1:-1:0 
        for i = 1:1:bits
            if(sc_functions(i,l) == 0)
                %f-function
%                 fprintf("f:L(%d,%d,%d)L(%d,%d,%d)R(%d,%d,%d)\n",i+sc_2nd_indxs(i,l),l+1,1,i,l+1,1,i+sc_2nd_indxs(i,l),l,1);
                L_messages(i,l,1) = bp_f(L_messages(i+sc_2nd_indxs(i,l),l+1,1),L_messages(i,l+1,1),R_messages(i+sc_2nd_indxs(i,l),l,1));       %getting values from l+1 stage
            else
                %g-function
%                 fprintf("g:L(%d,%d,%d)L(%d,%d,%d)R(%d,%d,%d)\n",i+sc_2nd_indxs(i,l),l+1,1,i,l+1,1,i+sc_2nd_indxs(i,l),l,1);
                L_messages(i,l,1) = bp_g(L_messages(i+sc_2nd_indxs(i,l),l+1,1),L_messages(i,l+1,1),R_messages(i+sc_2nd_indxs(i,l),l,1));     %getting values from l+1 stage + partial_sum
            end
        end
    end
    R_messages(reverse_order(non_frozen_indxs),1) = L_messages(reverse_order(non_frozen_indxs),1);
    L_messages
    R_messages
end
for bit = non_frozen_indxs
    if( (L_messages(reverse_order(bit),1)+R_messages(reverse_order(bit),1)) < 0)       %if it's not frozen bit, update value
        outputs(reverse_order(bit))=1;
    end
end
end