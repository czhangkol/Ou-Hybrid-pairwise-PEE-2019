%输出压缩后的overhead，用于重构C_Block
function [ind,CompressC]=Comp_Oh(S_Block,C_Block,Qyx)
B=size(Qyx,2);
CompressC=[];
ind=0;

for y=0:B-1
    Pos=find(S_Block==y);
    Condi_C=C_Block(Pos);
    L=size(Condi_C,1);
    if(L)
        ch1=(Qyx(y+1,:)==1);
        p1=sum(ch1);
        if(p1==0)
            Condi_C=Condi_C+1;
            Frequency=ones(L,B);
            for j=1:B
                Frequency(:,j)=Qyx(y+1,j)*Frequency(:,j);
            end
            [Comp]=arith_encode(Condi_C,Frequency);
            Len=size(Comp,1);
            CompressC(ind+1:ind+Len)=Comp;
            ind=ind+Len;
            Comp=[];
        end
    end
end