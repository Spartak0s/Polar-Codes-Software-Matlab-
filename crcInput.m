function output_crc = crcInput(input,crc,len_crc)
% both inputs: dec2bin() or hexToBinaryVector()
len_input = length(input);
right_padded = zeros(1,len_input + len_crc);
right_padded(1:len_input) = input;
crc_array = zeros(1,len_crc+1);
crc_array(1) = 1;               %crc is given without the first 1!!!!! ISO
crc_array(2:len_crc+1) = crc; % always 1 the first element
for i = len_crc+1:1:len_input+len_crc
    if(right_padded(1:len_input) == 0 )
        break;
    elseif(right_padded(i-len_crc) == 0)
        continue;
    else
        right_padded(i-len_crc:i) = bitxor(right_padded(i-len_crc:i),crc_array);
    end
end
output_crc = right_padded(len_input+1 : len_input+len_crc);
end

