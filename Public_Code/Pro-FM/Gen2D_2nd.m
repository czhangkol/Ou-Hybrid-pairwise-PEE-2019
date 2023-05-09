function [Ehis,ED_shift] = Gen2D_2nd(E,E2,NL,T)

index = length(E)/2;

F = zeros(1,2*index);
F2 = zeros(1,2*index);
indexbis = 0;
ED_shift = 0;
for i = 1:2*index
    if NL(ceil(i/2)) < T
        if E(i) <= 1
            indexbis = indexbis+1;
            F(indexbis) = E(i);
            F2(indexbis) = E2(i);            
        else
            ED_shift = ED_shift+1;
        end
    end
end
F = F(1:indexbis);
F2 = F2(1:indexbis);

ii = 1;
Exx = zeros(1,index);
Eyy = zeros(1,index);
Exx2 = zeros(1,index);
Eyy2 = zeros(1,index);

his = zeros(2,2);
for i = 1:floor(indexbis/2)
    Exx(ii) = F(2*i-1);
    Eyy(ii) = F(2*i);
    Exx2(ii) = F2(2*i-1);
    Eyy2(ii) = F2(2*i);       
    his(1+Exx(ii),1+Eyy(ii)) = his(1+Exx(ii),1+Eyy(ii)) + 1;
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