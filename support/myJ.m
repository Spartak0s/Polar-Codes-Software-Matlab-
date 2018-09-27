function J=myJ(x)
H1=.3073; H2=.8935; H3=1.1064;
J=(1-2^(-H1*x^(2*H2)))^H3;
 end