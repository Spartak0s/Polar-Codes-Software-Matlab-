function y = f(x1,x2)
%f(?a,?b) proccess
%Min-Sum Algorithm (MSA) deployed
y = sign(x1)*sign(x2)*min(abs(x1),abs(x2));
end