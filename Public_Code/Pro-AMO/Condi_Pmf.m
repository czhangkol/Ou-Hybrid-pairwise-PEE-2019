function [P_sy,Qxy,Qyx]=Condi_Pmf(px,py)
% clc;clear;
% px=[0.1,0.7,0.2];
% a=1.5;
B=size(px,1);
P_S(1)=0;
for i=1:B
    P_S(i+1)=P_S(i)+px(i);
end

P_Y(1)=0;
for i=1:B
    P_Y(i+1)=P_Y(i)+py(i);
end

for s=0:(B-1)
    for y=0:(B-1)
        P_sy(s+1,y+1)=min(P_S(s+2),P_Y(y+2))-max(P_S(s+1),P_Y(y+1));
        if(P_sy(s+1,y+1)<0)
            P_sy(s+1,y+1)=0;
        end
        Qxy(s+1,y+1)= P_sy(s+1,y+1)/(px(s+1)+eps);
        Qyx(s+1,y+1)= P_sy(s+1,y+1)/(py(y+1)+eps);
    end
end
Qyx=Qyx';
end