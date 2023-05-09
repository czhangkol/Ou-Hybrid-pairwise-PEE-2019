%M是消息序列，Cover是载体序列，取值0到B-1，px是Cover的pmf
function [Final_Stego,dist,MLen,Last_OH,Qxy]=OPTM(Cover,T,EmRate)
% clc;clear;
Qxy = [];
dist = 0;
r = 0;
MLen = 0;
Last_OH = 0;
%Cover
C_Len=floor(length(Cover)/2)*2;
B_Coef=15;%控制段长的因子
% T=6;%只取[-T，T]之间的值对



%生成codetable and decodetable
CodeTable=zeros(2*T+2,2*T+2); %此处修改为2(T+1), T = 1时包括-2，-1,0,1
DecodeTable=zeros((2*T+2)^2,2);
for i=-T-1:T  %此处可以改成-T-1:T
    for j=-T-1:T
        a1=i+T+1; %让取值从0开始
        a2=j+T+1;
        CodeTable(a1+1,a2+1)=a1*(2*T+2)+a2;
    end
end

for i=0:(2*T+2)^2-1
    a2=mod(i,2*T+2);
    a1=(i-a2)/(2*T+2);
    DecodeTable(i+1,1)=a1-T-1;
    DecodeTable(i+1,2)=a2-T-1;
end


Ind=zeros(C_Len/2,1);
pfor=1;

for i=1:2:C_Len-1
    if((abs(2*Cover(i)+1)-1)/2<=T && (abs(2*Cover(i+1)+1)-1)/2<=T) % 此处改成(abs(2*Cover(i)+1)-1)/2, 使得a和-a-1都变成a
        Ind(pfor)=i;
        Final_Cover(2*pfor-1)=Cover(i);
        Final_Cover(2*pfor)=Cover(i+1);
        cover2(pfor)=CodeTable(Cover(i)+T+2,Cover(i+1)+T+2);  
         
        pfor=pfor+1;
    end
end
Final_Stego=Final_Cover;%Final_Cover是模拟的载体
N=pfor-1; %N 是二维载体长度
B=(2*T+2)^2;


for i=0:B-1
    st=(cover2==i);
    H2(i+1)=sum(st);
end
px=H2/N;
px=px';
%小概率校正
ZeroPos=(px<=eps);
ZeroNum=size(ZeroPos,2);
px(ZeroPos)=10*ones(ZeroNum,1)/N;
px(ZeroPos)=0.0000001;
px=px/sum(px);

P_S(1)=0;
for i=2:B+1
    P_S(i)=P_S(i-1)+px(i-1);  % 似乎是累积概率
end

%预留一段处理overhead
L_px=compressFun(H2);%传载体分布需要的比特数
ParaL=L_px+B*B_Coef;% B*B_Coef是一段的长度，预留出一段，用LSB替换嵌倒数第二段的Overhead
CoverL=N;%载体长度
cover2=cover2';
Stego=cover2;
%cover3=cover2(ParaL+1:N);


% distortion matrix example: d(x,y)=(x-y)^2
Dxy=zeros(B,B);
for xx=0:B-1
    for yy=0:B-1
        a1=DecodeTable(xx+1,1);
        a2=DecodeTable(xx+1,2);
        b1=DecodeTable(yy+1,1);
        b2=DecodeTable(yy+1,2);
        Dxy(xx+1,yy+1)=(a1-b1)^2+(a2-b2)^2; %%%尚未定义距离矩阵
%         if (a1-b1)^2 > 1 || (a2-b2)^2 > 1 %最大修改量为1
%             Dxy(xx+1,yy+1) = 99999;
%         end

if a1 == 0 && a2 == 2 &&  b1 == -1 && b2 == 2    
    Dxy(xx+1,yy+1) = 9999999;    
end

if a1 == 2 && a2 == 0 &&  b1 == 2 && b2 == -1  
    Dxy(xx+1,yy+1) = 9999999;    
end
        
%         if a1 >= 0 && a2 >= 0
%             if b1 >= 0 && b2 >= 0
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
%         
%         if a1 >= 0 && a2 <= -1
%             if b1 >= 0 && b2 <= -1
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
%         
%         if a1 <= -1 && a2 >= 0
%             if b1 <= -1 && b2 >= 0
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
%         
%         if a1 <= -1 && a2 <= -1
%             if b1 <= -1 && b2 <= -1
%                 continue
%             else
%                Dxy(xx+1,yy+1) = 6;
%             end
%         end
        
    end
end

H_X=h(px); %计算熵
r=EmRate;
flag=1;
j=1;
t=clock;
while (flag&&j<2)
    [py]=max_entropy_br(px,Dxy,0);
    r_max=h(py)-H_X;
    if(r>r_max)
        disp('too large embedding rate');
    end
    flag=(r<=r_max);
    if(flag)
       %[py]=Esti_rate(px,Dxy,r,r_max,H_X);
       Hy=(r+H_X)*log(2);%求嵌入率对应的H(Y)，并用自然对数表示
       py=min_distortion_br(px,Dxy,Hy);
       [P_sy,Qxy,Qyx]=AnyDistortion(px,py,Dxy); %%P_xy是联合分布；Qxy是x—>y的转移概率；Qyx是y—>x的转移概率；
%        ZeroPos=(Qyx<=0.0001);
%        ZeroNum=size(ZeroPos,2);
%        Qyx(ZeroPos)=0;
       %理论界
       D(j)=0;
       for s=0:(B-1)
            for y=0:(B-1)
                D(j)=D(j)+P_sy(s+1,y+1)*Dxy(s+1,y+1);
            end
       end
       R(j)=h(py)-H_X;

    
       %编码
       [MLen,modi_cover,Last_OH]=recursive_construction(px,py,Qxy,Qyx,cover2,H2,B,B_Coef);%recursive_construction_new(cover2,B,a);
       OverHead=Last_OH+L_px;%存储载体分布和恢复最后一段需要的比特数
       %MLen=MLen-OverHead;
       MLen=MLen-Last_OH;
       Stego=modi_cover;
       if sum(Stego < 0) >=1
           break
       end
%        temp=(rand(OverHead,1)<0.5);
%        Stego(1:OverHead)=2*floor(Stego(1:OverHead)/2)+temp;%模拟LSB替换嵌入OverHead
%        for k=1:OverHead
%            if(Stego(k)>(2*T+1)^2-1)
%                Stego(k)=(2*T+1)^2-1;
%            end
%        end
       rate(j)=MLen/(N*2); %此处嵌入率是相对点对，除以2改成对每个点
       for i=1:N
           Final_Stego(2*i-1)=DecodeTable(Stego(i)+1,1);
           Final_Stego(2*i)=DecodeTable(Stego(i)+1,2);
       end
       DI=(Final_Stego-Final_Cover).^2;
       dist(j)=sum(DI); %此处平均失真是相对点对，除以2改成对每个点
%        r=r+5000/512^2;
   end
   j=j+1;
end
% rate(1)=0;
% dist(1)=0;
% e=etime(clock,t)



% FG=figure('Pos',[150 100 530 460]);
% AX=axes('Pos',[0.12 0.12 0.83 0.85]);
% L1=plot(D,R,'-^',dist,rate,'--o');
% XL=xlabel('Distortion'); YL=ylabel('Embedding rate');
% LG=legend('Upper bound','Proposed code',4);
% set(AX,'FontSize',[12]);
% set(XL,'FontSize',[12]);
% set(YL,'FontSize',[12]);
% set(LG,'FontSize',[12]);
% grid;
% set(L1(1),'Color',[0 0 0],'LineWidth',[1.3]);
% set(L1(2),'Color',[0 0 0],'MarkerSize',[10],'LineWidth',[1.3]);

% dist = (dist+dist2(1:length(dist2)))/2;
% rate = (rate+rate2(1:length(dist2)))/2;



end      