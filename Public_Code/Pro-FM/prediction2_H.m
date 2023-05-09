function [Exx,Eyy,NL3,xpos_E,ypos_E,indexbis,MSE,Iw] = prediction2_H(I,Capacity,T1,metricEC,metricED)

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
   for j = 3:2:B-1 

        
        p7 = I(i-1,j-2);                 p1 = I(i-1,j);

                        p4 = I(i,j-1);   x = I(i  ,j); p2 = I(i  ,j+1);

        p5 = I(i+1,j-2); y = I(i+1,j-1); p3 = I(i+1,j);  

                        p6 = I(i+2,j-1);             p8 = I(i+2,j+1);

                             
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
NL = NL(1:index);
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
    ypos2(2*i) = ypos(i)-1;
end



%%%%%%%%%% F and new 2D/3D EC/ED
F = zeros(1,2*index);
F2 = zeros(1,2*index);
G = zeros(1,2*index);
G2 = zeros(1,2*index);

xpos_S = zeros(1,2*index);
ypos_S = zeros(1,2*index);
xpos_E = zeros(1,2*index);
ypos_E = zeros(1,2*index);

NL3 = zeros(1,2*index);

indexbis = 0 ;%used for pariwise
indextri = 0; %used for 1D shifting


for i = 1:2*index
    if NL(ceil(i/2)) < T1
        if E(i) < 2
            indexbis = indexbis+1;
            F(indexbis) = E(i);
            F2(indexbis) = E2(i);
            xpos_E(indexbis) = xpos2(i);
            ypos_E(indexbis) = ypos2(i);
            NL3(indexbis) = NL2(i);
        else
            indextri = indextri+1;
            G(indextri) = E(i);
            G2(indextri) = E2(i);
            xpos_S(indextri) = xpos2(i);
            ypos_S(indextri) = ypos2(i);
            
        end
    end
       
end



F = F(1:indexbis);
F2 = F2(1:indexbis);
NL3 = NL3(1:indexbis);
G = G(1:indextri);
G2 = G2(1:indextri);
 
xpos_S = xpos_S(1:indextri);
ypos_S = ypos_S(1:indextri);
xpos_E = xpos_E(1:indexbis);
ypos_E = ypos_E(1:indexbis);


indexbis+indextri-2*index;
EC = 0;
ED = indextri;% 映射1中大于2的，做shift移位所带来的失真


%%%%%%%%%% 2D

Exx = zeros(1,floor(indexbis/2));
Eyy = zeros(1,floor(indexbis/2));

%序号：       1          2         3           4          5          6        7          8          9
%2D bin：(0.5,0.5), (0.5,1.5), (1.5,0.5), (1.5,1.5), (0.5,2.5), (2.5,0.5), (1.5,2.5), (2.5,1.5), (2.5,2.5)

ii= 1;
for i = 1:floor(indexbis/2)
    
    if EC >= Capacity
        break
    end
    
    stopX = xpos_E(2*i);
    stopY = ypos_E(2*i);
    
    x = F2(2*i-1)+0.5;
    y = F2(2*i)+0.5;
    Exx(ii) = F2(2*i-1);
    Eyy(ii) = F2(2*i);
    ii = ii + 1;
    if abs(x) == 0.5 && abs(y) == 0.5
        ind  = 1;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 0.5 && abs(y) == 1.5
        ind  = 2;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 1.5 && abs(y) == 0.5
        ind  = 3;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 1.5 && abs(y) == 1.5
        ind  = 4;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 0.5 && abs(y) == 2.5
        ind  = 5;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 2.5 && abs(y) == 0.5
        ind  = 6;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 1.5 && abs(y) == 2.5
        ind  = 7;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 2.5 && abs(y) == 1.5
        ind  = 8;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    if abs(x) == 2.5 && abs(y) == 2.5
        ind  = 9;
        EC = EC+metricEC(ind);
        ED = ED+metricED(ind);
        continue
    end
    
end
% ii = ii -1;
% Exx = Exx(1:ii);
% Eyy = Eyy(1:ii);
% indexbis = ii;

indexbis = floor(indexbis/2);
MSE = 0;

%---------------shifting e > 1 and e < -2 for n < T1
for i = 1:indextri
    ii = i;
    %     if (xpos_S(ii)<= stopX && ypos_S(ii) <=stopY) || xpos_S(ii) <= stopX-1
    %
    %     Iw(xpos_S(ii),ypos_S(ii)) = I(xpos_S(ii),ypos_S(ii)) + sign(G2(ii))*1;
    %     MSE = MSE + 1;
    %     else
    %         break
    %     end
    if (xpos_S(ii) == stopX && ypos_S(ii) > stopY) || xpos_S(ii) > stopX
        break
    else
        Iw(xpos_S(ii),ypos_S(ii)) = I(xpos_S(ii),ypos_S(ii)) + sign(G2(ii))*1;
        MSE = MSE + 1;
    end
end


end


