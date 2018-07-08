timestamp = [num2str(start_time(1),'%04d') '_' num2str(start_time(2),'%02d') '_' num2str(start_time(3),'%02d') '_' num2str(start_time(4),'%02d') '_' num2str(start_time(5),'%02d') '_' num2str(start_time(6),'%2.0f')];
result_path = './results/';
addpath('support');
fast_run = 1;           %1:run of optimal-matlab code, 0:run of hardware-code (suboptimal f/g)
Fading_Channel = 0;     %0: AWGN, 1:Fading Channel
Fading_Independent = 0; %if Fading_Channel = 1
quasi = 0;              % quasi channel
fading_channel = 'TU120';   %custom matlab channel
fix_seed = 1;           %1:fix data, 0:random data
code_rate = 1/4;
if fix_seed
    rng(sum(100*clock));
else
    rand('seed',123456);
end
%Simulation values
min_fer_errors = 100;
min_codewords = 100;
NbitsPerSymbol = 1;
constDims = 1;
%EbNo
EbNo_dB = -2:4;
snrdb_values =EbNo_dB+10*log10(double(code_rate*NbitsPerSymbol*2/constDims));
%Polar-Code values
capacity = 0.5; %I(W), Channel's W Capacity