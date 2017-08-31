function path_metric = pm_update(path_metric,llr_array,outputs)
    path_metric = path_metric + log(1+ exp(-(1-2*outputs)*llr_array));
end

