function [Iw, nBit, dis] = single2Embedding(I,Payload, pFor, IX, IY, IXpos, IYpos)
Iw = I;

IX = IX + 0.5;
IY = IY + 0.5;

data = randperm(512^2);
dis = 0;
nBit = 0;
nData = 1;
for iP=1:pFor
    ii = 2*iP-1;
    
    %Is payload satisfied?
    if(nBit < Payload)
    %embedding
    %|x| and |y| = 0.5
    if(abs(IY(iP))==0.5 && abs(IX(iP))==0.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),3);
        nData = nData + 1;
        nBit = nBit+log2(3);
        dis = dis + 2/3;
        if(bit ==1)
            Iw(IXpos(ii),IYpos(ii)) = I(IXpos(ii),IYpos(ii)) + sign(IX(iP))*1;
        elseif(bit ==2)
            Iw(IXpos(ii+1),IYpos(ii+1)) = I(IXpos(ii+1),IYpos(ii+1)) + sign(IY(iP))*1;
        end
        continue
    end
    
    %|x| and |y| = 1.5
    if(abs(IY(iP))==1.5 && abs(IX(iP))==1.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),2);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 1;
        if(bit ==1)
            Iw(IXpos(ii),IYpos(ii)) = I(IXpos(ii),IYpos(ii)) + sign(IX(iP))*1;
            Iw(IXpos(ii+1),IYpos(ii+1)) = I(IXpos(ii+1),IYpos(ii+1)) + sign(IY(iP))*1;
        end
        continue
    end
    
    %|y| = 0.5
    if(abs(IY(iP))==0.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),2);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 3/2;
        if(bit == 0)
            Iw(IXpos(ii),IYpos(ii)) = I(IXpos(ii),IYpos(ii)) + sign(IX(iP))*1;            
        elseif(bit ==1)
            Iw(IXpos(ii),IYpos(ii)) = I(IXpos(ii),IYpos(ii)) + sign(IX(iP))*1;
            Iw(IXpos(ii+1),IYpos(ii+1)) = I(IXpos(ii+1),IYpos(ii+1)) + sign(IY(iP))*1;
        end
        continue
    end
   %
   
    %|x| = 0.5
    if(abs(IX(iP))==0.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),2);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 3/2;
        if(bit == 0)
            Iw(IXpos(ii+1),IYpos(ii+1)) = I(IXpos(ii+1),IYpos(ii+1)) + sign(IY(iP))*1;
        elseif(bit ==1)
            Iw(IXpos(ii),IYpos(ii)) = I(IXpos(ii),IYpos(ii)) + sign(IX(iP))*1;
            Iw(IXpos(ii+1),IYpos(ii+1)) = I(IXpos(ii+1),IYpos(ii+1)) + sign(IY(iP))*1;
        end
        continue
    end
   
    dis = dis + 2;
    Iw(IXpos(ii),IYpos(ii)) = I(IXpos(ii),IYpos(ii)) + sign(IX(iP))*1;
    Iw(IXpos(ii+1),IYpos(ii+1)) = I(IXpos(ii+1),IYpos(ii+1)) + sign(IY(iP))*1;
    
    end
     %
end

MSE = sum(sum(abs(Iw-I)));
% ps = 10*log10(255^2*d1*d2/MSE);
  
end