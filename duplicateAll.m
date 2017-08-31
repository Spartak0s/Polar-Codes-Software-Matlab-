function [path_metrics,outputs,threads] = duplicateAll(test_path_metrics,outputs,threads,i)
%DUPLICATES path l and changing the outputs(i) for u={0,1}
    for thread=2*threads:-2:1
        path_metrics(thread) = test_path_metrics(thread);
        outputs(thread,:) = outputs(thread/2,:);
        outputs(thread,i) = 1;
        path_metrics(thread-1) = test_path_metrics(thread-1);
        outputs(thread-1,:) = outputs(thread/2,:);
        outputs(thread-1,i) = 0;
    end
    threads = threads*2;
end

