function y = g(x1,x2,x3) % x3 is S partial
%g(?a,?b,S) process
y = x1*power(-1,x3)+x2 ;        %power(x1,1-2*x3)*x2; lr
end