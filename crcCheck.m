function remainder = crcCheck(input,crc,len_crc)
% both inputs: dec2bin() or hexToBinaryVector()
len_input = length(input);
crc_array = zeros(1,len_crc+1);
crc_array(1) = 1;
crc_array(2:len_crc+1) = crc;
for i = len_crc+1:1:len_input
    if(input(1:len_input) == 0 )
        break;
    elseif(input(i-len_crc) == 0)
        continue;
    else
        input(i-len_crc:i) = bitxor(input(i-len_crc:i),crc_array);
    end
end

if(input == 0)
    remainder = 0;
else
    remainder = 1;
end
end
