function outputArg1 = bp_f(a1,a2,a3)
%BP function f (for xor) of bp-decoding in polar codes
a = 0.9375;
outputArg1 = a * sign(a1) * sign(a2 + a3) * min(abs(a1), abs(a2 + a3));
end