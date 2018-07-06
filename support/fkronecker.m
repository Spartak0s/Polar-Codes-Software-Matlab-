function Fn = fkronecker( bits )
%FKRONECKER, makes the Fn !!!array NOT REVERSED!!!
F = [1,0;1,1];
Fn = F;
for i=1:1:log2(bits)-1
    Fn=kron(F,Fn);
    %Fn=sparse(Fn);
end
end

