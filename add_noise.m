function noised = add_noise(inputs,SNR)
%takes modulated inputs, adds AWGN noise with SNR in db.
noised = awgn(inputs,SNR,'measured');
end


%correct