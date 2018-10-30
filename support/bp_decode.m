function outputs = bp_decode(llr_inputs,frozen_bits,sc_functions,sc_2nd_indxs,iterations)
non_frozen_indxs = find(frozen_bits == 1);
frozen_indxs = find(frozen_bits == 0);
bits = length(llr_inputs);
Nstages = log2(bits);
reverse_order = bitrevorder(1:1:bits); %same as 0:1:bits-1
L_messages = zeros(bits,log2(bits)+1);
R_messages = zeros(bits,log2(bits)+1);
outputs = zeros(1,bits);        %NOT bit_reversed_array
%% Iteration 1
L_messages(:,log2(bits)+1) = llr_inputs.';
R_messages(reverse_order(frozen_indxs),1) = 1e10;
%% <--: right to left pass
L_messages = bp_right_to_left(L_messages,R_messages,sc_2nd_indxs,sc_functions,Nstages);
iteration = 1;
while(iteration < iterations)
    iteration = iteration + 1;  
    %%  Iteration-initialize
    L_messages(:,log2(bits)+1) = llr_inputs.';%+R_messages(:,log2(bits)+1);
%     R_messages(reverse_order(non_frozen_indxs),1) = L_messages(reverse_order(non_frozen_indxs),1);
    R_messages(reverse_order(frozen_indxs),1) = 1e10;
    %% -->: left to right pass
    R_messages = bp_left_to_right(L_messages,R_messages,sc_2nd_indxs,sc_functions,Nstages);
    %% <--: right to left pass
    L_messages = bp_right_to_left(L_messages,R_messages,sc_2nd_indxs,sc_functions,Nstages);
%     R_messages(reverse_order(non_frozen_indxs),1) = L_messages(reverse_order(non_frozen_indxs),1);
end
for bit = non_frozen_indxs
    if( (L_messages(reverse_order(bit),1)+R_messages(reverse_order(bit),1)) < 0)       %if it's not frozen bit, update value
        outputs(bit)=1;
    end
end
end

function R_messages = bp_left_to_right(L_messages,R_messages,sc_2nd_indxs,sc_functions,Nstages)
    for l= 1:1:Nstages
        for i = 1:1:pow2(Nstages)
            if(sc_functions(i,l) == 0)
                %f-function
%                 fprintf("f:R(%d,%d)R(%d,%d)L(%d,%d)\n",i+sc_2nd_indxs(i,l),l,i,l,i+sc_2nd_indxs(i,l),l+1);
                R_messages(i,l+1) = bp_f(R_messages(i,l),R_messages(i+sc_2nd_indxs(i,l),l),L_messages(i+sc_2nd_indxs(i,l),l+1));       %getting values from l+1 stage
            else
                %g-function
%                 fprintf("g:R(%d,%d)R(%d,%d)L(%d,%d)\n",i+sc_2nd_indxs(i,l),l,i,l,i+sc_2nd_indxs(i,l),l+1);
                R_messages(i,l+1) = bp_g(R_messages(i,l),R_messages(i+sc_2nd_indxs(i,l),l),L_messages(i+sc_2nd_indxs(i,l),l+1));     %getting values from l+1 stage + partial_sum
            end
        end
    end
end

function L_messages = bp_right_to_left(L_messages,R_messages,sc_2nd_indxs,sc_functions,Nstages)
    for l= Nstages:-1:1 %Arikan log2(bits)-1:-1:0 
        for i = 1:1:pow2(Nstages)
            if(sc_functions(i,l) == 0)
                %f-function
    %                 fprintf("f:L(%d,%d,%d)L(%d,%d,%d)R(%d,%d,%d)\n",i+sc_2nd_indxs(i,l),l+1,1,i,l+1,1,i+sc_2nd_indxs(i,l),l,1);
                L_messages(i,l) = bp_f(L_messages(i,l+1),L_messages(i+sc_2nd_indxs(i,l),l+1),R_messages(i+sc_2nd_indxs(i,l),l));       %getting values from l+1 stage
            else
                %g-function
    %                 fprintf("g:L(%d,%d,%d)L(%d,%d,%d)R(%d,%d,%d)\n",i+sc_2nd_indxs(i,l),l+1,1,i,l+1,1,i+sc_2nd_indxs(i,l),l,1);
                L_messages(i,l) = bp_g(L_messages(i,l+1),L_messages(i+sc_2nd_indxs(i,l),l+1),R_messages(i+sc_2nd_indxs(i,l),l));     %getting values from l+1 stage + partial_sum
            end
        end
    end
end