function best_outputs =  list_decode(llr_inputs,frozen_bits,L)
threads = 1;
N = length(llr_inputs);
llr_array = zeros(N,L);
path_metrics = zeros(1,L);  % !!TOGETHER with outputs, Path-Metric estimations
outputs = zeros(L,N); % !!TOGETHER with pathe_metrics, u estimated outputs
test_path_metrics = zeros(1,2*L); %Pl,for each u={0,1}
reverse_order = bitrevorder(1:1:N); %same as 0:1:N-1
sc_array = sc_array_initialize(N);  %--BIT_REVERSED ARRAY-- outputs(i,l,dimension) // dimension= 1 values -- 2 !! if 0 then f else g !!-- 3 2nd input
partial_sum_adders = partial_sums_initialize(N);   %!!!!! NOT bit_reversed array -- %outputs(z,i,l) -- l stage ,bit Ui is added,z is the number of g adder04

for i=1:1:N %Arikan 0:1:N-1
    [llr_array] = decode3(llr_inputs,llr_array,outputs,partial_sum_adders,sc_array,reverse_order,N,threads,i);  %removed outputs, from outputs of decode3
    %decode3 giving u estimated and llr values, for each thread
    if(frozen_bits(i) == 0)
        for thread=1:1:threads
            outputs(thread,i) = 0;  %u output update for frozen bits
            path_metrics(thread) = pm_update(path_metrics(thread),llr_array(i,thread),outputs(thread,i));    %update path-metrics values
        end
    else
        for thread=1:1:threads
            test_path_metrics(2*thread-1) = pm_update(path_metrics(thread),llr_array(i,thread),0);
            test_path_metrics(2*thread) = pm_update(path_metrics(thread),llr_array(i,thread),1);
        end
        if(threads < L)%(2*threads <= L)% last condition
            [path_metrics,outputs,threads] = duplicateAll(test_path_metrics,outputs,threads,i); %Duplicate all paths
        else
            taf = median(test_path_metrics(1:2*threads));
            removed = 0;
            %killing the threads above median
            copy_path_metrics = test_path_metrics;
            thread = 2;
            while thread<=2*threads %%fixed:WRONG 2*threads somewhere
                if((test_path_metrics(thread-1)>taf) && (test_path_metrics(thread)>taf))
                    test_path_metrics(thread) = [];
                    test_path_metrics(2*L) = 0;
                    test_path_metrics(thread-1) = [];
                    test_path_metrics(2*L) = 0;
                    path_metrics(thread/2) = [];
                    path_metrics(L) = 0;
                    outputs(thread/2,:) = [];
                    outputs = [outputs;zeros(1,N)];
                    threads = threads - 1;
                    thread = thread-2;
                    %removed = removed + 1;
                end
                thread = thread + 2;
            end
            %threads = threads - removed;
            for thread=threads:-1:1
                if ((test_path_metrics(2*thread)<taf) && (test_path_metrics(2*thread-1)>taf))
                    path_metrics(thread) = test_path_metrics(2*thread);
                    outputs(thread,i) = 1;
                elseif ((test_path_metrics(2*thread-1)<taf) && (test_path_metrics(2*thread)>taf))
                    path_metrics(thread) = test_path_metrics(2*thread-1);
                    outputs(thread,i) = 0;
                else
                    [path_metrics,outputs,threads] = duplicatePath(path_metrics,test_path_metrics,outputs,threads,thread,i);
                end
            end
        end
        
    end
end
% computer the best_outputs
[values,indexes] = sort(path_metrics);
j=1;
while(values(j) == 0)
    j = j + 1;
end
best_outputs = outputs(indexes(1),:);
end