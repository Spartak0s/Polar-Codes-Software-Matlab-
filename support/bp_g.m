function outputArg1 = bp_g(a1,a2,a3)
%BP function g (for equality) of bp-decoding in polar codes
a = 0.9375;
outputArg1 = a1 + a * sign(a2) * sign(a3) * min(abs(a2), abs(a3));
end