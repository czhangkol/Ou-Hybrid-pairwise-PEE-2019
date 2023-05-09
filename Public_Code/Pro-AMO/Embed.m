%function recursive ZZW based on all zeros ZZW
function [MLen,S_Block]=Embed(C_Block,M_Block,Qxy)
% clear;
% clc;
% N=1000;
% C_Block=rand(1,N)<0.2;
% M_Block=rand(1,N)<0.5;
% Delta0=0.3;
S_Block=C_Block;
MLen=0;
B=size(Qxy,2);
n=zeros(B,1);
for x=0:B-1
    p=find(Qxy(x+1,:)==1);
    if(p)
        S_Block(Pos)=(p-1)*ones(n,1);
    else
        Pos=find(C_Block==x);
        n(x+1)=size(Pos,1);
    end
end
    
Len_Blc=sum(n);
Frequency=ones(Len_Blc,B);

Star=0;
for x=0:B-1
    if(n(x+1))
        for j=1:B
            Frequency(Star+1:Star+n(x+1),j)=Qxy(x+1,j)*Frequency(Star+1:Star+n(x+1),j);
        end
        Star=Star+n(x+1);
    end
end


[DeSeq,MLen,De_Len]=arith_decode(M_Block,Frequency);
DeSeq=DeSeq-1;
Star=0;
for x=0:B-1
    if(n(x+1))
        Pos=find(C_Block==x);
        S_Block(Pos)=DeSeq(Star+1:Star+n(x+1));
        Star=Star+n(x+1);
    end
end

        



