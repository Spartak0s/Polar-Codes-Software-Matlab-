function [ capacity_array2 ] = capacities2( N,EbN0dB, R )
%CAPACITIES2 Summary of this function goes here
%   Detailed explanation goes here

esn0=R*10^(EbN0dB/10);   
arg=sqrt(8*esn0);
n = log2(N);
I=myJ(arg);    %initialization
% new=myJinv(I);     %inverse checks
for m=1:n  %tree depth loop
    vec=I;  
    for mm=1:2^(m-1)
      temp1=myJinv(1-vec(mm));
      temp2=myJinv(vec(mm));
      arg1=sqrt(2*temp1^2);
      arg2=sqrt(2*temp2^2);
         capacity_array2(2*mm-1)=1-myJ(arg1);  
         capacity_array2(2*mm)=myJ(arg2); 

    end
    I=capacity_array2;  %I vector now twice as big as previous
end

end

