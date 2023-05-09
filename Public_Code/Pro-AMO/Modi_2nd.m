function [Iw,dist,r,Dis_Shift,T,Qxy] = Modi_2nd(I,Capacity)

[A,B] = size(I);
Ex = zeros(1,A*B);
Ey = zeros(1,A*B);
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);

index = 0;

% 计算预测残差
index = 0;
RR = zeros(4,1000);
for i = 2:2:A-2
   for j = 3:2:B-1         
        p7 = I(i-1,j-2);                 p1 = I(i-1,j);

                        p4 = I(i,j-1);   x = I(i  ,j); p2 = I(i  ,j+1);

        p5 = I(i+1,j-2); y = I(i+1,j-1); p3 = I(i+1,j);  

                        p6 = I(i+2,j-1);             p8 = I(i+2,j+1);
                             
       
       index = index+1;
       px(index) = ceil((p1+p2+p3+p4)/4);
       py(index) = ceil((p3+p4+p5+p6)/4);
       Ex(index) = x - px(index);
       Ey(index) = y - py(index);
       NL(index) = abs(p1-p2)+abs(p2-p3)+abs(p3-p4)+abs(p4-p1)+abs(p3-p6)+abs(p6-p5)+abs(p5-p4)+abs(p4-p7)+abs(p3-p8); 
       xpos(index) = i;
       ypos(index) = j;
    end
end


Ex = Ex(1:index);
Ey = Ey(1:index);
px = px(1:index);
py = py(1:index);
eX = Ex;
eY = Ey;
NL = NL(1:index); %都加1以便于后续数组表示, 1 <= nl <= maxNL + 1
xpos = xpos(1:index);
ypos = ypos(1:index);


%%%%%%%%%% E
E = zeros(1,2*index);
E2 = zeros(1,2*index);
xpos2 = zeros(1,2*index);
ypos2 = zeros(1,2*index);
NL2 = zeros(1,2*index);
pre = zeros(1,2*index);
for i = 1:index
    E(2*i-1) = Ex(i);
    E(2*i-0) = Ey(i);
    pre(2*i-1) = px(i);
    pre(2*i-0) = py(i);
    
    E2(2*i-1) = eX(i);
    E2(2*i-0) = eY(i);
    NL2(2*i-1) = NL(i);
    NL2(2*i) = NL(i);
    xpos2(2*i-1) = xpos(i);
    xpos2(2*i) = xpos(i)+1;
    ypos2(2*i-1) = ypos(i);
    ypos2(2*i) = ypos(i)-1;    
end

dist = 0;
r = 0;
for T = 1:max(NL)+1
    Cover = zeros(size(E));
    tempxpos = zeros(size(xpos2));
    tempypos = zeros(size(ypos2));
    pfor = 1;
    for i = 1:2*index
        if E(i)>= -2 && E(i) <=1 && NL2(i) < T
            Cover(pfor) = E(i);
            
            tempxpos(pfor) = xpos2(i);
            tempypos(pfor) = ypos2(i);
            pfor = pfor + 1;
        end
    end
    pfor = pfor - 1;
    Cover = Cover(1:pfor);
    tempxpos = tempxpos(1:pfor);
    tempypos = tempypos(1:pfor);
    
    Len = floor(length(Cover)/2)*2;
    Cover = Cover(1:Len);
    tempxpos = tempxpos(1:Len);
    tempypos = tempypos(1:Len);
    
    modiRange = 2; %修改范围在-3到2之间，其中-2到1有值，剩余的是空的
    
    if  Len <= 5000 %载体足够长
        continue
    end
    [Stego,dist,mLen,Last_OH,Qxy] = OPTM(Cover,modiRange,Capacity/(Len/2));
 
    if mLen  >= Capacity && dist > 0
        r = mLen;
        break
    end
    
end

%反变换到像素域
Iw = I;
for ii = 1:Len
    i =  tempxpos(ii);
    j = tempypos(ii);
    [~,ind] = find(((xpos2 == i)+ (ypos2 == j))==2);
    Iw(i,j) = pre(ind)+Stego(ii);
end

 

MSE = sum(sum((I-Iw).^2));
% dist = dist*floor(length(Cover)/2)*2;
% r = r*floor(length(Cover)/2)*2;

%shifting distortion
 
indextri = 0;
G = zeros(size(E));
xpos_S = zeros(size(xpos));
ypos_S = zeros(size(ypos));
for i = 1:ind
    if (E(i) <=-3 || E(i) >= 2) && NL2(i) < T
        
        indextri = indextri+1;
        G(indextri) = E(i); 
        xpos_S(indextri) = xpos2(i);
        ypos_S(indextri) = ypos2(i);
        
    end
       
end
G = G(1:indextri);
xpos_S = xpos_S(1:indextri);
ypos_S = ypos_S(1:indextri);
Dis_Shift = 0;
for i = 1:indextri
    ii = i;
    Iw(xpos_S(ii),ypos_S(ii)) = I(xpos_S(ii),ypos_S(ii)) + sign(G(ii))*1;
    Dis_Shift = Dis_Shift + 1;

end



end