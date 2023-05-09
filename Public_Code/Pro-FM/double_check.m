clear all
clc

I = double(imread('Baboon.bmp'));
[bin_LM bin_LM_len I] = LocationMap(I);
Iw = I;
[d1 d2] = size(I);

noiseLevel = zeros(1,65025);
iPos = zeros(1,65025);
jPos = zeros(1,65025);
errorX = zeros(1,65025);
errorY = zeros(1,65025);
his2D = zeros(511,511);
pFor = 1;
EC = zeros(1,300);
ED = zeros(1,300);

Capacity = 10000;
Map1 = [0 0 3 3 3 3 3 3 3 ;
0 0 0 0 1 3 3 3 3 ;
2 0 1 3 3 1 1 3 1 ;
2 0 0 1 2 1 1 3 1 ;
2 1 3 2 1 1 1 1 1 ;
2 1 2 1 1 1 1 1 1 ;
2 2 2 2 2 2 1 1 1 ;
2 2 2 2 1 1 1 1 1 ;
2 1 1 1 1 1 1 1 1   ];
    
Map2 = [0 0 0 3 3 3 3 3 3 ;
0 0 0 0 1 1 3 3 3 ;
2 3 0 1 3 1 3 3 1 ;
2 2 1 3 3 1 1 3 1 ;
2 2 2 3 1 1 1 1 1 ;
2 2 1 1 1 1 1 1 1 ;
2 2 1 1 1 1 1 1 1 ;
2 2 2 2 1 1 1 1 1 ;
2 2 1 1 1 1 1 1 1  ];
[mapSize1 mapSize2] = size(Map1);


Payload = Capacity/2 + bin_LM_len;

data = randperm(512^2);

%1st prediction
for i = 2:2:d1-2
   for j = 2:2:d2-2 
       ii = i+1;
       jj = j+1;
                           a = I(i-1,j);                     g = I(i-1,j+2); 

           b = I(i  ,j-1); x = I(i  ,j); d = I(i  ,j+1);

                           c = I(i+1,j); y = I(i+1,j+1); e = I(i+1,j+2);

          h = I(i+2,j-1);                  f = I(i+2,j+1);

          noiseLevel(pFor) = abs(a-b)+abs(b-c)+abs(c-d)+abs(d-a)+abs(c-f)+abs(f-e)+abs(e-d)+abs(d-g)+abs(c-h);
          errorX(pFor) = I(i,j) -  ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4);
          errorY(pFor) =  I(ii,jj) - ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4);
          iPos(pFor) = i;
          jPos(pFor) = j;
          pFor = pFor + 1;
    end
end
pFor = pFor -1;
errorX = errorX + 0.5;
errorY = errorY + 0.5;
    
    
    
% T selection
cFlag = 0;
for T = 1:max(noiseLevel)
    if cFlag == 1
        break
    end
    
nbit = 0;
for i=1:pFor
    if nbit >= Capacity/2
       cFlag = 1;
       break
    end
    
  if(noiseLevel(i) <= T)
      
      mCpos = floor(abs(errorX(i)))+1;
      mRpos = floor(abs(errorY(i)))+1;
      N = 0;
      flagg = zeros(1,4);
      if mCpos <=mapSize1-1 && mRpos <=mapSize2-1
          
      if Map1(mRpos,mCpos) == 0
          N = N + 1;
          flagg(1) = 1;
      end
      if Map1(mRpos,mCpos+1) == 3
          flagg(2) = 1;
          N = N + 1;
      end
      if Map1(mRpos+1,mCpos) == 2
          flagg(3) = 1;
          N = N + 1;
      end
      if Map1(mRpos+1,mCpos+1) == 1
          flagg(4) = 1;
          N = N + 1;
      end
      if N > 1
         nbit = nbit + log2(N);
      end    
      
      continue
      end
      
      if abs(errorX(i)) == 0.5
          nbit = nbit + 1;
          continue
      end
      
      if abs(errorY(i)) == 0.5
          nbit = nbit + 1;
          continue
      end
      
      
      
  end
end

end
T = T - 1;

%---------------------------1st data embedding

nbit = 0;
for i=1:pFor
    if nbit >= Capacity/2
       break
    end
    
  if(noiseLevel(i) <= T)
      
      mCpos = floor(abs(errorX(i)))+1;
      mRpos = floor(abs(errorY(i)))+1;
      N = 0;
      flagg = zeros(1,4);
      if mCpos <=mapSize1-1 && mRpos <=mapSize2-1
          
      if Map1(mRpos,mCpos) == 0
          N = N + 1;
          flagg(1) = 1;
      end
      if Map1(mRpos,mCpos+1) == 3
          flagg(2) = 1;
          N = N + 1;
      end
      if Map1(mRpos+1,mCpos) == 2
          flagg(3) = 1;
          N = N + 1;
      end
      if Map1(mRpos+1,mCpos+1) == 1
          flagg(4) = 1;
          N = N + 1;
      end
      
      if N > 1
         nbit = nbit + log2(N);
      end
      bit = mod(data(fix(i/255)*500+mod(i,255)),N);
      switch N
          case 1
              %1
              if all(flagg == [1 0 0 0])
              end
              %2
              if all(flagg == [0 1 0 0])
                  Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
              end
              %3
              if all(flagg == [0 0 1 0])
                  Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
              end
              %4
              if all(flagg == [0 0 0 1])
                  Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
                  Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
              end
          case 2
              %1
              if all(flagg == [1 1 0 0])
                  if bit == 1
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  end
              end
              %2
              if all(flagg == [1 0 1 0])
                  if bit == 1
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
              %3
              if all(flagg == [1 0 0 1])
                  if bit == 1
                  Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
                  Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
                  end
              end
              %4
              if all(flagg == [0 1 1 0])
                  if bit == 0
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  else
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
              %5
              if all(flagg == [0 1 0 1])
                  if bit == 0
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  else
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
              %6
              if all(flagg == [0 0 1 1])
                  if bit == 0
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  else
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
          case 3
               %1
              if all(flagg == [1 1 1 0])
                  if bit == 1
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  elseif bit == 2
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
              %2
              if all(flagg == [1 1 0 1])
                  if bit == 1
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  elseif bit == 2
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
              %3
              if all(flagg == [1 0 1 1])
                  if bit == 1
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  elseif bit == 2
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
              %4
              if all(flagg == [0 1 1 1])
                  if bit == 0
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  elseif bit == 1
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  else
                     Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                     Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1; 
                  end
              end
          case 4
              if bit == 1
                  Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
              elseif bit == 2
                  Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
              elseif bit == 3
                  Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
                  Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
              end
      end
      
      continue
      end
      
      if abs(errorX(i)) == 0.5
          nbit = nbit + 1;
          if mod(data(fix(i/255)*500+mod(i,255)),2) == 0
          Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;   
          else
          Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
          Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
          end
          continue
      end
      
      if abs(errorY(i)) == 0.5
          nbit = nbit + 1;
          if mod(data(fix(i/255)*500+mod(i,255)),2) == 0
          Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
          else
          Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
          Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
          end
          continue
      end
      
      Iw(iPos(i),jPos(i)) = I(iPos(i),jPos(i)) + sign(errorX(i))*1;
      Iw(iPos(i)+1,jPos(i)+1) = I(iPos(i)+1,jPos(i)+1) + sign(errorY(i))*1;
      
      
  end
end
nbit2 = nbit;


%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noiseLevel = zeros(1,65025);
iPos = zeros(1,65025);
jPos = zeros(1,65025);
errorX = zeros(1,65025);
errorY = zeros(1,65025);
pFor = 1;

%2nd prediction
for i = 2:2:d1-2
   for j = 3:2:d2-1 
             g = Iw(i-1,j-2);               a = Iw(i-1,j);

                             d = Iw(i,j-1); x = Iw(i  ,j); b = Iw(i  ,j+1);

             e = Iw(i+1,j-2); y = Iw(i+1,j-1); c = Iw(i+1,j);  

                             f = Iw(i+2,j-1);             h = Iw(i+2,j+1);
       ii = i+1;
       jj = j-1;
       noiseLevel(pFor) = abs(a-b)+abs(b-c)+abs(c-d)+abs(d-a)+abs(c-f)+abs(f-e)+abs(e-d)+abs(d-g)+abs(c-h);
       errorX(pFor) = Iw(i,j) - ceil( (Iw(i-1,j) + Iw(i,j-1) + Iw(i+1,j) + Iw(i,j+1))/4 );
       errorY(pFor) =  Iw(ii,jj) -  ceil( (Iw(ii-1,jj) + Iw(ii,jj-1) + Iw(ii+1,jj) + Iw(ii,jj+1))/4 );
       iPos(pFor) = i;
       jPos(pFor) = j;
       pFor = pFor + 1;
    end
end
pFor = pFor -1;
errorX = errorX + 0.5;
errorY = errorY + 0.5;
    
      
% T selection
cFlag = 0;
for T = 1:max(noiseLevel)
    if cFlag == 1
        break
    end
    
nbit = 0;
for i=1:pFor
    if nbit >= Capacity/2
       cFlag = 1;
       break
    end
    
  if(noiseLevel(i) <= T)
      
      mCpos = floor(abs(errorX(i)))+1;
      mRpos = floor(abs(errorY(i)))+1;
      N = 0;
      flagg = zeros(1,4);
      if mCpos <=mapSize1-1 && mRpos <=mapSize2-1
          
      if Map2(mRpos,mCpos) == 0
          N = N + 1;
          flagg(1) = 1;
      end
      if Map2(mRpos,mCpos+1) == 3
          flagg(2) = 1;
          N = N + 1;
      end
      if Map2(mRpos+1,mCpos) == 2
          flagg(3) = 1;
          N = N + 1;
      end
      if Map2(mRpos+1,mCpos+1) == 1
          flagg(4) = 1;
          N = N + 1;
      end
      if N > 1
         nbit = nbit + log2(N);
      end    
      
      continue
      end
      
      if abs(errorX(i)) == 0.5
          nbit = nbit + 1;
          continue
      end
      
      if abs(errorY(i)) == 0.5
          nbit = nbit + 1;
          continue
      end
      
      
      
  end
end

end
T = T - 1;

%---------------------------2nd data embedding

nbit = 0;
for i=1:pFor
    if nbit >= Capacity/2
       break
    end
    
  if(noiseLevel(i) <= T)
      
      mCpos = floor(abs(errorX(i)))+1;
      mRpos = floor(abs(errorY(i)))+1;
      N = 0;
      flagg = zeros(1,4);
      if mCpos <=mapSize1-1 && mRpos <=mapSize2-1
          
      if Map2(mRpos,mCpos) == 0
          N = N + 1;
          flagg(1) = 1;
      end
      if Map2(mRpos,mCpos+1) == 3
          flagg(2) = 1;
          N = N + 1;
      end
      if Map2(mRpos+1,mCpos) == 2
          flagg(3) = 1;
          N = N + 1;
      end
      if Map2(mRpos+1,mCpos+1) == 1
          flagg(4) = 1;
          N = N + 1;
      end
      
      if N > 1
         nbit = nbit + log2(N);
      end
      bit = mod(data(fix(i/255)*500+mod(i,255)),N);
      switch N
          case 1
              %1
              if all(flagg == [1 0 0 0])
              end
              %2
              if all(flagg == [0 1 0 0])
                  Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
              end
              %3
              if all(flagg == [0 0 1 0])
                  Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
              end
              %4
              if all(flagg == [0 0 0 1])
                  Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
                  Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
              end
          case 2
              %1
              if all(flagg == [1 1 0 0])
                  if bit == 1
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  end
              end
              %2
              if all(flagg == [1 0 1 0])
                  if bit == 1
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
              %3
              if all(flagg == [1 0 0 1])
                  if bit == 1
                  Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
                  Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
                  end
              end
              %4
              if all(flagg == [0 1 1 0])
                  if bit == 0
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  else
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
              %5
              if all(flagg == [0 1 0 1])
                  if bit == 0
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  else
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
              %6
              if all(flagg == [0 0 1 1])
                  if bit == 0
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  else
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
          case 3
               %1
              if all(flagg == [1 1 1 0])
                  if bit == 1
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  elseif bit == 2
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
              %2
              if all(flagg == [1 1 0 1])
                  if bit == 1
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  elseif bit == 2
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
              %3
              if all(flagg == [1 0 1 1])
                  if bit == 1
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  elseif bit == 2
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
              %4
              if all(flagg == [0 1 1 1])
                  if bit == 0
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                  elseif bit == 1
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  else
                     Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1; 
                     Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1; 
                  end
              end
          case 4
              if bit == 1
                  Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
              elseif bit == 2
                  Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
              elseif bit == 3
                  Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
                  Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
              end
      end
      
      continue
      end
      
      if abs(errorX(i)) == 0.5
          nbit = nbit + 1;
          if mod(data(fix(i/255)*500+mod(i,255)),2) == 0
          Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
          else
          Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
          Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;   
          end
          continue
      end
      
      if abs(errorY(i)) == 0.5
          nbit = nbit + 1;
          if mod(data(fix(i/255)*500+mod(i,255)),2) == 0
          Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
          else
          Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
          Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;   
          end
          continue
      end
      
      Iw(iPos(i),jPos(i)) = Iw(iPos(i),jPos(i)) + sign(errorX(i))*1;
      Iw(iPos(i)+1,jPos(i)-1) = Iw(iPos(i)+1,jPos(i)-1) + sign(errorY(i))*1;
      
      
  end
end

MSE = sum(sum(abs(Iw-I).^2));
nbit2 = nbit2+ nbit
psnr = 10*log10(255^2*d1*d2/MSE)



