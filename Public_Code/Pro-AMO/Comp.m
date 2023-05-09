%压缩频数信息x，首先作差分序列，记录负数位置，然后都差分序列和位置序列分别压缩。
function [y]=Comp(x)
% clc;clear;
% load Cover;
% N=size(Cover,1);
% B=max(Cover)+1;
% HIST=hist(Cover,B);
% x=HIST;
% 

B=size(x,2);
Max_Val=max(x);
j=find(x==Max_Val);
Diff(1)=x(1);
for i=2:j
    Diff(i)=x(i)-x(i-1);
end
for i=j+1:B
    Diff(i)=x(i-1)-x(i);
end
    
%%压缩位置序列
%Diff=x;
Pos=(Diff<0);
Pos=double(Pos);
p1=sum(Pos)/B;
Frequency=ones(B,2);
Frequency(:,1)=(1-p1)*Frequency(:,1);
Frequency(:,2)=p1*Frequency(:,2);
Pos=Pos+1;
Pos=reshape(Pos,B,1);
[Comp1]=arith_encode(Pos,Frequency);
oh1=size(Comp1,1);

%%压缩差分序列
Diff=abs(Diff);
temp=max(Diff);
temp=log2(temp);
Digit=ceil(temp);
BiSeq=de2bi(Diff,Digit);
BiSeq=reshape(BiSeq,B*Digit,1);
q1=sum(BiSeq)/(B*Digit);
Frequency=ones(B*Digit,2);
Frequency(:,1)=(1-q1)*Frequency(:,1);
Frequency(:,2)=q1*Frequency(:,2);
BiSeq=BiSeq+1;
[Comp2]=arith_encode(BiSeq,Frequency);
oh2=size(Comp2,1);
y=oh1+oh2+ceil(log2(B)); %ceil(log2(B))存储最大值的位置
%end


