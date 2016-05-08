function y = f(x1,x2)
%f(?a,?b) proccess
y = sign(x1)*sign(x2)*min(abs(x1),abs(x2));%2*atanh(tanh(x1/2)*tanh(x2/2)); %(1+(x1*x2))/(x1+x2); lr
end