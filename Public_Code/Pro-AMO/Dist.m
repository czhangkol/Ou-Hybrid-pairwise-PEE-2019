function y=Dist(a,b,T)
[a1,a2]=Decode(a,T);
[b1,b2]=Decode(b,T);
y=(a1-b1)^2+(a2-b2)^2;
end