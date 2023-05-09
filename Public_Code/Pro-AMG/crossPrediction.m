function [errorX, errorY,bits,PSNR] = crossPrediction(I,payload,mode)
[d1 d2] = size(I);

errorX = zeros(1,65025);
errorY = zeros(1,65025);
noiseLevel = zeros(1,65025);
pFor = 1;

switch mode
    case 1
        %prediction
        for i = 2:2:d1-2
            for j = 2:2:d2-2
                ii = i-1;
                jj = j-1;
                if ii>=2 && ii<=d1-1 && jj>=2 && jj<=d2-1
                errorX(pFor) = I(i,j) -  ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4);
                errorY(pFor) =  I(ii,jj) - ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4);
                noiseLevel(pFor) = abs(I(i-1,j)-I(i,j-1))+abs(I(i,j-1)-I(i+1,j))+abs(I(i+1,j)-I(i,j+1))+abs(I(i,j+1)-I(i-1,j))+...
                    +abs(I(ii-1,jj)-I(ii,jj-1))+abs(I(ii,jj-1)-I(ii+1,jj))+abs(I(ii+1,jj)-I(ii,jj+1))+abs(I(ii,jj+1)-I(ii-1,jj));
                end
                
                pFor = pFor + 1;
            end
        end
        pFor = pFor -1;
    case 2
        for i = 2:2:d1-2
            for j = 2:2:d2-2
                ii = i-1;
                jj = j+1;
                   
                if ii>=2 && ii<=d1-1 && jj>=2 && jj<=d2-1
                errorX(pFor) = I(i,j) -  ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4);
                errorY(pFor) =  I(ii,jj) - ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4);
                noiseLevel(pFor) = abs(I(i-1,j)-I(i,j-1))+abs(I(i,j-1)-I(i+1,j))+abs(I(i+1,j)-I(i,j+1))+abs(I(i,j+1)-I(i-1,j))+...
                    +abs(I(ii-1,jj)-I(ii,jj-1))+abs(I(ii,jj-1)-I(ii+1,jj))+abs(I(ii+1,jj)-I(ii,jj+1))+abs(I(ii,jj+1)-I(ii-1,jj));
                end
                pFor = pFor + 1;
            end
        end
        pFor = pFor -1;
    case 3
        for i = 2:2:d1-2
            for j = 2:2:d2-2
                ii = i+1;
                jj = j-1;
                
                if ii>=2 && ii<=d1-1 && jj>=2 && jj<=d2-1
                errorX(pFor) = I(i,j) -  ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4);
                errorY(pFor) =  I(ii,jj) - ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4);
                noiseLevel(pFor) = abs(I(i-1,j)-I(i,j-1))+abs(I(i,j-1)-I(i+1,j))+abs(I(i+1,j)-I(i,j+1))+abs(I(i,j+1)-I(i-1,j))+...
                    +abs(I(ii-1,jj)-I(ii,jj-1))+abs(I(ii,jj-1)-I(ii+1,jj))+abs(I(ii+1,jj)-I(ii,jj+1))+abs(I(ii,jj+1)-I(ii-1,jj));
                end
                pFor = pFor + 1;
            end
        end
        pFor = pFor -1;
    case 4
        for i = 2:2:d1-2
            for j = 2:2:d2-2
                ii = i+1;
                jj = j+1;
                
                if ii>=2 && ii<=d1-1 && jj>=2 && jj<=d2-1
                errorX(pFor) = I(i,j) -  ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4);
                errorY(pFor) =  I(ii,jj) - ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4);
                noiseLevel(pFor) = abs(I(i-1,j)-I(i,j-1))+abs(I(i,j-1)-I(i+1,j))+abs(I(i+1,j)-I(i,j+1))+abs(I(i,j+1)-I(i-1,j))+...
                    +abs(I(ii-1,jj)-I(ii,jj-1))+abs(I(ii,jj-1)-I(ii+1,jj))+abs(I(ii+1,jj)-I(ii,jj+1))+abs(I(ii,jj+1)-I(ii-1,jj));
                end
                pFor = pFor + 1;
            end
        end
        pFor = pFor -1;
end

errorX = errorX(1:pFor);
errorY = errorY(1:pFor);
noiseLevel = noiseLevel(1:pFor);
%EC estimation
EC = [];
n = 1;
distortion = [];
errorX = errorX + 0.5;
errorY = errorY + 0.5;

for T = 0:1:max(noiseLevel)
    type1N = 0;
    type2N = 0;
    typeShift = 0;
for i=1:pFor
   if(noiseLevel(i) <= T)

  if(abs(errorX(i))==0.5 && abs(errorY(i))==0.5)
       type1N = type1N + log2(3);
       continue
  end
   
   if(abs(errorX(i))==1.5 && abs(errorY(i))==1.5)
       type2N = type2N + 1;
       continue
   end
   
   if(abs(errorX(i))==0.5)
       type2N = type2N + 1;
       continue
   end
   if(abs(errorY(i))==0.5)
       type2N = type2N + 1;
       continue
   end
   
   typeShift =  typeShift + 1;
   
   end
   
   if(type1N + type2N >= payload)
    break;
   end

end
EC(n) = type1N + type2N;
distortion(n) =  typeShift+type1N*2/3+type2N;

   if(EC(n) >= payload)
    break;
   end
n = n+1;
end
Thresh = T;
bits = EC(n);
PSNR =  10*log10(255^2*pFor/distortion(n));


end