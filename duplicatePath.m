function [path_metrics,outputs,threads] = duplicatePath(path_metrics,test_path_metrics,outputs,threads,path,i)
%DUPLICATES path l and changing the outputs(i) for u={0,1}
    for thread=threads:-1:path+1
        path_metrics(thread+1) = path_metrics(thread);
        outputs(thread+1,:) = outputs(thread,:);
    end
    path_metrics(path+1) = test_path_metrics(2*path);
    path_metrics(path) = test_path_metrics(2*path-1);
    outputs(path+1,:) = outputs(path,:);
    outputs(path+1,i) = 1;
    outputs(path,i) = 0;
    threads = threads+1;
end

