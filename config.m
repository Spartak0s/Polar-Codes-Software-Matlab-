timestamp = [num2str(start_time(1),'%04d') '_' num2str(start_time(2),'%02d') '_' num2str(start_time(3),'%02d') '_' num2str(start_time(4),'%02d') '_' num2str(start_time(5),'%02d') '_' num2str(start_time(6),'%2.0f')];
result_path = './results/';
%% Configure parameters
%Polar-Code values
capacity = 0.5; %I(W), Channel's W Capacity
n_values = [4,5,6,7,8];     %value of N
code_rate = 1/4;
%EbNo
EbNo_dB = 0:5; %AWGN -4:2 %Fading 0:2:10
%Channel
Fading_Channel = 0;     %0: AWGN, 1:Fading Channel
%fading only parameters
Fading_Independent = 0; %if Fading_Channel = 1
quasi = 0;              % quasi channel
fading_channel = 'TU120';   %custom matlab channel
%seed
fix_seed = 1;           %1:fix data, 0:random data
%Simulation values
decoding_algorithm = 'MSA';     % Set as 'SPA' for Sum-Product algorithm , or 'MSA' for Min-Sum Algorithm.
fast_run = 1;           %1:run of optimal-matlab code + mex-files, 0:run of hardware-code (suboptimal f/g)
min_fer_errors = 100;   %minimum frame errors to count
min_codewords = 100;    %minimum codewords to count
NbitsPerSymbol = 1;     %modulation parameter
constDims = 1;          %modulation parameter
snrdb_values =EbNo_dB+10*log10(double(code_rate*NbitsPerSymbol*2/constDims));
%% Parfor configuration
FLAG_Enable_parpool=0;    % 0: Disable, 1: Enable
parcore_nums = 4;
%% Initializations
%add required matlab paths
restoredefaultpath;
addpath('support');
addpath(['./support/f_function/' decoding_algorithm]);  % for l_f function.
if(fast_run == 1)   % for mex-files
    addpath('./support/mex_files');
end
%initialize seed
if ~fix_seed
    rng(sum(100*clock));
else
    rand('seed',123456);
end
%initialize parcorenum
if FLAG_Enable_parpool
    % determine the number of physical cores
    corenum = feature('numcores');
    parcorenum = parcore_nums;
    % parcorenum = 15; %  # of workers
    p = gcp('nocreate');   % Not create new pool if it does not exist
    if isempty(p)
        p = parcluster('local');
        p.NumWorkers = parcorenum;
        parpool(p, p.NumWorkers);
    end
    if p.NumWorkers ~= parcorenum
        delete(p);
        p = parcluster('local');
        p.NumWorkers = parcorenum;
        parpool(p, p.NumWorkers);
    end
    parallel_frames = 100*parcorenum;
else
    parallel_frames = 100;
end
%% Variable Initializations
bit_error_rate = zeros(length(n_values),length(snrdb_values));
fer_error_rate = zeros(length(n_values),length(snrdb_values));
legends = strings(1,length(n_values));
codewords = zeros(1,length(snrdb_values));