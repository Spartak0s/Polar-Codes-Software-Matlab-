function Jinv=myJinv(y)
H1=.3073; H2=.8935; H3=1.1064;
Jinv=((-1/H1)*log2(1-y^(1/H3)))^(1/(2*H2));
end

