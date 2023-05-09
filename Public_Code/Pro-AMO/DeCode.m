function [a1,a2]=DeCode(b,T)
a2=mod(b,2*T+1);
a1=(b-a2)/(2*T+1);
a1=a1-T;
a2=a2-T;
end



