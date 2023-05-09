function [Ehis,his2,his_1D,his3,ED_shift] = Gen2D_1st(E,E2,NL,T)

index = length(E)/2;



F = zeros(1,2*index);
F2 = zeros(1,2*index);
F3 = zeros(1,2*index);
indexbis = 0;
ED_shift = 0;
indextri = 0;
for i = 1:2*index
    if NL(ceil(i/2)) < T
        if E(i) <= 1
            indexbis = indexbis+1;
            indextri = indextri + 1;
            F(indexbis) = E(i);
            F2(indexbis) = E2(i);       
            F3(indextri) = E2(i); 
        else
            ED_shift = ED_shift+1;
            G2(ED_shift) = E2(i);
        end
    end
end
F = F(1:indexbis);
F2 = F2(1:indexbis);
F3 = F3(1:indextri);
ii = 1;
Exx = zeros(1,index);
Eyy = zeros(1,index);
Exx2 = zeros(1,index);
Eyy2 = zeros(1,index);

his = zeros(256,256);
his2 = zeros(511,511);
his_1D = zeros(1,511);
for i = 1:floor(indexbis/2)
    Exx(ii) = F(2*i-1);
    Eyy(ii) = F(2*i);
    Exx2(ii) = F2(2*i-1);
    Eyy2(ii) = F2(2*i);       
    his(1+Exx(ii),1+Eyy(ii)) = his(1+Exx(ii),1+Eyy(ii)) + 1;
    his2(256+Exx2(ii),256+Eyy2(ii)) = his2(256+Exx2(ii),256+Eyy2(ii)) + 1;
    ii = ii + 1;
end

for i = 1:ED_shift       
    his_1D(256+G2(i)) = his_1D(256+G2(i)) + 1;
end

his3 = zeros(511,511,511);
for i = 1:floor(indextri/3)
    e1 = F3(3*i-2);
    e2 = F3(3*i-1);
    e3 = F3(3*i-1);
    Eyy2(ii) = F2(2*i);       
    
    his3(256+e1,256+e2,256+e3) = his3(256+e1,256+e2,256+e3) + 1;
    ii = ii + 1;
end

ii = ii - 1;
map = [1 2;
       3 4];
Ehis = zeros(1,4);   


for i = 1:2
    for j = 1:2
        index = map(i,j);
        Ehis(index) = his(i,j);
    end
end





end