function channel_out = add_noise(inputs,constDims,Fading_Channel,Fading_Independent,fading_channel,snr)
%takes modulated inputs, adds AWGN/Fading noise with SNR in db.
if Fading_Channel && ~Fading_Independent
    legacychannelsim(true);
end
% CHANNEL %
if Fading_Channel	% Fading Channel
    if Fading_Independent	% i.i.d. fading channel
        %Time-domain
        if ~quasi
            fading = complex(randn(1,length(inputs)), randn(1,length(inputs)))/sqrt(2); %iid Rayleigh
        else
            fading = complex(randn(1), randn(1))/sqrt(2);   %Quasi-static Rayleight
        end
%         attenu = abs(fading);
%         phase = angle(fading);
    else            % Multipath Fading Channel
        if(strcmp(fading_channel,'TU120'))
            fs = 2048e3;        %if frequency domain fs = 1536e3;
            fd = 20;            %DAB-values for TU120
            c = 3e8; f=175.28e6;
            [ch,chanprofile] = stdchan(1/fs,fd,'cost207RAx6');
            fading = filter(ch, ones(1,length(inputs)));
            attenu = abs(fading);
            phase = angle(fading);
        else
            ch = rayleighchan(5/345,1);   %iid Rayleight Frequency domain
            fading = filter(ch, ones(1,length(inputs))); %Time response
            attenu = abs(fading);
            phase = angle(fading);
        end
    end
    in_decoder_tmp = fading.*inputs;
    %in_decoder_tmp = attenu.*out_mod;
else	% AWGN Channel
    % Tail-biting %
    in_decoder_tmp = inputs;
    % Received symbols amplitude
    fading = 1;
    attenu = 1;
    phase = 0;
end

noise_dev = sqrt(10^(-snr/10)/constDims);
%BPSK
channel_out = noise_dev*(randn(1,length(inputs))) + in_decoder_tmp;
%QPSK    
% channel_out = noise_dev*complex(randn(1,length(inputs)),randn(1,length(inputs))) ...
%         + in_decoder_tmp;

%old noise addition based on awgn
% channel_out = awgn(inputs,snr,'measured');
end


%correct