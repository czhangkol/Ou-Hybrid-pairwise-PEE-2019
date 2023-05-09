function [T1,T2] = process_H(I,Capacity)

Iw = I;

[A,B] = size(I);
Ex = zeros(1,A*B);
Ey = zeros(1,A*B);
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);

index = 0;
RR = zeros(4,1000);
for i = 2:2:A-2
    for j = 2:2:B-2
        
        
                          p1 = I(i-1,j);                   p7 = I(i-1,j+2);
        p2 = I(i,j-1);    x  = I(i,j);   p4 = I(i,j+1);
                         p3 = I(i+1,j);  y  = I(i+1,j+1);  p5 = I(i+1,j+2);
        p8 = I(i+2,j-1);                 p6 = I(i+2,j+1);
        px = ceil((p1+p2+p3+p4)/4);
        py = ceil((p3+p4+p5+p6)/4);
        index = index+1;
        Ex(index) = x - px;
        Ey(index) = y - py;
        NL(index) = abs(p1-p2)+abs(p2-p3)+abs(p3-p4)+abs(p4-p1)+abs(p3-p6)+abs(p6-p5)+abs(p5-p4)+abs(p4-p7)+abs(p3-p8);
        xpos(index) = i;
        ypos(index) = j;
    end
end

Ex = Ex(1:index);
Ey = Ey(1:index);
eX = Ex;
eY = Ey;
NL = NL(1:index)+1; %都加1以便于后续数组表示, 1 <= nl <= maxNL + 1
xpos = xpos(1:index);
ypos = ypos(1:index);

%%%%%%%%%% {a,-a-1} --> a
Ex = abs(2*Ex+1);
Ex = (Ex-1)/2;
Ey = abs(2*Ey+1);
Ey = (Ey-1)/2;


%%%%%%%%%% E
E = zeros(1,2*index);
E2 = zeros(1,2*index);
xpos2 = zeros(1,2*index);
ypos2 = zeros(1,2*index);
NL2 = zeros(1,2*index);

ec1 = zeros(1,max(NL));
ec2 = zeros(1,max(NL));
ed1 = zeros(1,max(NL));
ed2 = zeros(1,max(NL));

for i = 1:index
    E(2*i-1) = Ex(i);
    E(2*i-0) = Ey(i);
    E2(2*i-1) = eX(i);
    E2(2*i-0) = eY(i);
    NL2(2*i-1) = NL(i);
    NL2(2*i) = NL(i);
    xpos2(2*i-1) = xpos(i);
    xpos2(2*i) = xpos(i)+1;
    ypos2(2*i-1) = ypos(i);
    ypos2(2*i) = ypos(i)+1;
    
end

for i = 1:2*index
    
    if E2(i) == 0 || E2(i) == -1
        ec2(NL2(i):max(NL)) = ec2(NL2(i):max(NL)) + 1;
        ed2(NL2(i):max(NL)) = ed2(NL2(i):max(NL)) + 0.5;
    else
        ed2(NL2(i):max(NL)) = ed2(NL2(i):max(NL)) + 1;
    end
    
    if E2(i) > 1 || E2(i)< -2
        ed1(NL2(i):max(NL)) = ed1(NL2(i):max(NL)) + 1;
    end
    
    
end

%-----------C++ implementation
[F,NL3,ec1,ed1_Plus,Exx2,Eyy2,pairnum] = hisGen(E,NL,NL2,index,max(NL));

Exx2 = Exx2(1:pairnum);
Eyy2 = Eyy2(1:pairnum);

ed1 = ed1+ed1_Plus;

%------------------debug 测试用
indexbis = 0;
for i = 1:2*index
    if NL2(i) <= 26
        if E(i) < 2
            indexbis = indexbis+1;
            F(indexbis) = E(i);
            F2(indexbis) = E2(i);
            xpos_E(indexbis) = xpos2(i);
            ypos_E(indexbis) = ypos2(i);
            NL3(indexbis) = NL2(i);
        end
    end
end

ii = 1;
Exx = zeros(1,index);
Eyy = zeros(1,index);
EC = 0;
ED = 0;
for i = 1:floor(indexbis/2)
    
    x = F2(2*i-1)+0.5;
    y = F2(2*i)+0.5;
    Exx(ii) = F(2*i-1);
    Eyy(ii) = F(2*i);
    ii = ii + 1;
    if abs(x) == 0.5 && abs(y) == 0.5
        EC = EC+log2(3);
        ED = ED+2/3;
        continue
    end
    if abs(x) == 1.5 && abs(y) == 1.5
        EC = EC+1;
        ED = ED+1;
        continue
    end
    if abs(x) == 0.5
        EC = EC+1;
        ED = ED+1.5;
        continue
    end
    
    if abs(y) == 0.5
        EC = EC+1;
        ED = ED+1.5;
        continue
    end
    
end

ii = ii - 1;
Exx = Exx(1:ii);
Eyy = Eyy(1:ii);
%------------------


rIndex = 0;

for T1 = 1:max(NL)
    for T2 = T1:max(NL)
        
        %%%%%%%%%% F and new 2D/3D EC/ED
        
        EC = 0;
        ED = 0;
        %----------- modify e for T1 < n < T2
        EC = EC + ec1(T2)- ec1(T1);
        ED = ED + ed1(T2)- ed1(T1);
        
        %----------- modify e for n <= T1
        EC = EC + ec2(T1);
        ED = ED + ed2(T1);
        
        
        rIndex = rIndex + 1;
        RR(1,rIndex) = EC;
        RR(2,rIndex) = ED;
        RR(3,rIndex) = T1;
        RR(4,rIndex) = T2;
        
    end
end

%%%%% 实验结果
RRR = zeros(4,rIndex);
k = 0;
for i = 1:rIndex
    if RR(1,i) >= 5000 && RR(2,i) > 0
        k = k+1;
        RRR(:,k) = RR(:,i);
    end
end
RR = RRR(:,1:k);
RRR = zeros(4,rIndex);

[~,ind] = sort(RR(2,:)./RR(1,:),'ascend');
RR(1,:) = RR(1,ind);
RR(2,:) = RR(2,ind);
RR(3,:) = RR(3,ind);
RR(4,:) = RR(4,ind);


ind = find(RR(1,:)>=Capacity,1,'first');
if isempty(ind)
    T1 = 9999;T2 = 9999;
else
    T1 = RR(3,ind); T2 =  RR(4,ind);
end

end