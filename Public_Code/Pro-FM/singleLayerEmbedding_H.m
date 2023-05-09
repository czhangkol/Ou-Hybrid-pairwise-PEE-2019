function [Iw, nBit, dis,MSE] = singleLayerEmbedding_H(I,Payload, pFor, errorX, errorY, iPos, jPos,childout)
Iw = I;

errorX = errorX + 0.5;
errorY = errorY + 0.5;

data = randperm(512^2);
dis = 0;
nBit = 0;
index = 1;

bit2 = mod(data,2);
bit3 = mod(data,3);
bit4 = mod(data,4);
ind2 = 1;
ind3 = 1;
ind4 = 1;

pFor = length(errorX);

MSE = 0;

for iP=1:pFor
    ii = 2*iP-1;
    
    %Is payload satisfied?
    if(nBit < Payload)
        %embedding
        %1
        if(abs(errorX(iP))==0.5 && abs(errorY(iP))==0.5)
            if isempty(childout{index,1})
                continue
            end
            bit = mod(data(fix(iP/255)*500+mod(iP,255)),length(childout{index,1}));
            
            if length(childout{index,1}) == 2
                bit = bit2(ind2);
                ind2 = ind2 + 1;
            elseif length(childout{index,1}) == 3
                bit = bit3(ind3);
                ind3 = ind3 + 1;
            elseif length(childout{index,1}) == 4
                bit = bit4(ind4);
                ind4 = ind4 + 1;
            end
           
            
            nBit = nBit+log2(length(childout{index,1}));
            switch length(childout{index,1})
                case 1                    
                    if ismember(2,childout{index,1})
                        MSE = MSE + 1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                    if ismember(3,childout{index,1}) 
                        MSE = MSE + 1;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    end
                    if ismember(4,childout{index,1})
                        MSE = MSE + 2;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                case 2
                    if ismember(1,childout{index,1})
                        if ismember(4,childout{index,1})
                            MSE = MSE + 1;
                        else
                            MSE = MSE + 0.5;
                        end                            
                        if(bit ==1 && ismember(2,childout{index,1}) )
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==1 && ismember(3,childout{index,1}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif(bit ==1 && ismember(4,childout{index,1}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end                        
                    end
                    
                    if ismember(2,childout{index,1}) && ismember(3,childout{index,1})
                        MSE = MSE + 1;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;                            
                        elseif bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;                             
                        end
                    end
                    
                    if ismember(2,childout{index,1}) && ismember(4,childout{index,1})
                        MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;                             
                        elseif bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(3,childout{index,1}) && ismember(4,childout{index,1})
                        MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                case 3
                    if ismember(2,childout{index,1}) && ismember(3,childout{index,1}) && ismember(4,childout{index,1})
                        MSE = MSE + 4/3;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit ==1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==2)
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(1,childout{index,1}) && ismember(2,childout{index,1}) && ismember(3,childout{index,1})
                        MSE = MSE + 2/3;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        
                    end
                    if ismember(1,childout{index,1}) && ismember(3,childout{index,1}) && ismember(4,childout{index,1})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(1,childout{index,1}) && ismember(2,childout{index,1}) && ismember(4,childout{index,1})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                case 4
                    MSE = MSE + 1;
                    if(bit ==1)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    elseif(bit ==2)
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    elseif(bit ==3)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
            end
            continue
        end
        
        %2
        if(abs(errorX(iP))==0.5 && abs(errorY(iP))==1.5)
            if isempty(childout{index,2})
                continue
            end
            bit = mod(data(fix(iP/255)*500+mod(iP,255)),length(childout{index,2}));
            if length(childout{index,2}) == 2
                bit = bit2(ind2);
                ind2 = ind2 + 1;
            elseif length(childout{index,2}) == 3
                bit = bit3(ind3);
                ind3 = ind3 + 1;
            elseif length(childout{index,2}) == 4
                bit = bit4(ind4);
                ind4 = ind4 + 1;
            end
            nBit = nBit+log2(length(childout{index,2}));
            switch length(childout{index,2})
                case 1                    
                    if ismember(5,childout{index,2})
                        MSE = MSE + 1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                    if ismember(4,childout{index,2})
                        MSE = MSE + 1;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    end
                    if ismember(7,childout{index,2})
                        MSE = MSE + 2;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                case 2
                    if ismember(7,childout{index,2})
                        MSE = MSE + 1;
                    else
                        MSE = MSE + 0.5;
                    end
                    if ismember(2,childout{index,2})
                        if(bit ==1 && ismember(5,childout{index,2}) )
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==1 && ismember(4,childout{index,2}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif(bit ==1 && ismember(7,childout{index,2}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                                        
                    if ismember(5,childout{index,2}) && ismember(7,childout{index,2})
                        MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                     if ismember(4,childout{index,2}) && ismember(7,childout{index,2})
                         MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                     end
                    
                      if ismember(5,childout{index,2}) && ismember(4,childout{index,2})
                          MSE = MSE + 1;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                      end
                    
                case 3
                    if ismember(4,childout{index,2}) && ismember(5,childout{index,2}) && ismember(7,childout{index,2})
                        MSE = MSE + 4/3;
                        if bit == 0
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif bit ==1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==2)
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(2,childout{index,2}) && ismember(5,childout{index,2}) && ismember(4,childout{index,2})
                        MSE = MSE + 2/3;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        
                    end
                    if ismember(2,childout{index,2}) && ismember(4,childout{index,2}) && ismember(7,childout{index,2})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(2,childout{index,2}) && ismember(5,childout{index,2}) && ismember(7,childout{index,2})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;  
                        elseif bit ==2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;                        
                        end
                    end
                    
                case 4
                    MSE = MSE + 1;
                    if(bit ==1)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    elseif(bit ==2)
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    elseif(bit ==3)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
            end
            continue
        end
                       
        %3
        if(abs(errorX(iP))==1.5 && abs(errorY(iP))==0.5)
            if isempty(childout{index,3})
                continue
            end
            bit = mod(data(fix(iP/255)*500+mod(iP,255)),length(childout{index,3}));
            if length(childout{index,3}) == 2
                bit = bit2(ind2);
                ind2 = ind2 + 1;
            elseif length(childout{index,3}) == 3
                bit = bit3(ind3);
                ind3 = ind3 + 1;
            elseif length(childout{index,3}) == 4
                bit = bit4(ind4);
                ind4 = ind4 + 1;
            end
            nBit = nBit+log2(length(childout{index,3}));
            switch length(childout{index,3})
                case 1                    
                    if ismember(4,childout{index,3})
                        MSE = MSE + 1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                    if ismember(6,childout{index,3})
                        MSE = MSE + 1;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    end
                    if ismember(8,childout{index,3})
                        MSE = MSE + 2;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                case 2
                    if ismember(3,childout{index,3})
                        if ismember(8,childout{index,3})
                            MSE = MSE + 1;
                        else
                            MSE = MSE + 0.5;
                        end
                        if(bit ==1 && ismember(4,childout{index,3}) )
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==1 && ismember(6,childout{index,3}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif(bit ==1 && ismember(8,childout{index,3}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                                        
                    if ismember(4,childout{index,3}) && ismember(8,childout{index,3})
                        MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                     if ismember(6,childout{index,3}) && ismember(8,childout{index,3})
                         MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                     end
                    
                      if ismember(4,childout{index,3}) && ismember(6,childout{index,3})
                        MSE = MSE + 1;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                      end
                    
                case 3
                    if ismember(4,childout{index,3}) && ismember(6,childout{index,3}) && ismember(8,childout{index,3})
                        MSE = MSE + 4/3;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit ==1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==2)
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(3,childout{index,3}) && ismember(4,childout{index,3}) && ismember(6,childout{index,3})
                        MSE = MSE + 2/3;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        
                    end
                    if ismember(3,childout{index,3}) && ismember(6,childout{index,3}) && ismember(8,childout{index,3})
                        MSE = MSE + 2/3;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(3,childout{index,3}) && ismember(4,childout{index,3}) && ismember(8,childout{index,3})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1; 
                        elseif bit ==2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;                        
                        end
                    end
                    
                case 4
                    MSE = MSE + 1;
                    if(bit ==1)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    elseif(bit ==2)
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    elseif(bit ==3)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
            end
            continue
        end
        
        %4
        if(abs(errorX(iP))==1.5 && abs(errorY(iP))==1.5)
            if isempty(childout{index,4})
                continue
            end
            bit = mod(data(fix(iP/255)*500+mod(iP,255)),length(childout{index,4}));
            if length(childout{index,4}) == 2
                bit = bit2(ind2);
                ind2 = ind2 + 1;
            elseif length(childout{index,4}) == 3
                bit = bit3(ind3);
                ind3 = ind3 + 1;
            elseif length(childout{index,4}) == 4
                bit = bit4(ind4);
                ind4 = ind4 + 1;
            end
            nBit = nBit+log2(length(childout{index,4}));
            switch length(childout{index,4})
                case 1                    
                    if ismember(7,childout{index,4})
                        MSE = MSE + 1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                    if ismember(8,childout{index,4})
                        MSE = MSE + 1;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    end
                    if ismember(9,childout{index,4})
                        MSE = MSE + 2;
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
                case 2
                    if ismember(4,childout{index,4})
                        if ismember(9,childout{index,4})
                            MSE = MSE + 1;
                        else
                            MSE = MSE + 0.5;
                        end
                        if(bit ==1 && ismember(7,childout{index,4}) )
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==1 && ismember(8,childout{index,4}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif(bit ==1 && ismember(9,childout{index,4}) )
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                                        
                    if ismember(7,childout{index,4}) && ismember(9,childout{index,4})
                        MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                     if ismember(8,childout{index,4}) && ismember(9,childout{index,4})
                         MSE = MSE + 1.5;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                     end
                    
                      if ismember(7,childout{index,4}) && ismember(8,childout{index,4})
                          MSE = MSE + 1;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        end
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                      end
                    
                case 3
                    if ismember(7,childout{index,4}) && ismember(8,childout{index,4}) && ismember(9,childout{index,4})
                        MSE = MSE + 4/3;
                        if bit == 0
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit ==1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        elseif(bit ==2)
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(4,childout{index,4}) && ismember(7,childout{index,4}) && ismember(8,childout{index,4})
                        MSE = MSE + 2/3;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                        
                    end
                    if ismember(4,childout{index,4}) && ismember(8,childout{index,4}) && ismember(9,childout{index,4})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        elseif bit == 2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                        end
                    end
                    
                    if ismember(4,childout{index,4}) && ismember(7,childout{index,4}) && ismember(9,childout{index,4})
                        MSE = MSE + 1;
                        if bit == 1
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1; 
                        elseif bit ==2
                            Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                            Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;                        
                        end
                    end
                    
                case 4
                    MSE = MSE + 1;
                    if(bit ==1)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                    elseif(bit ==2)
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    elseif(bit ==3)
                        Iw(iPos(ii),jPos(ii)) = I(iPos(ii),jPos(ii)) + sign(errorX(iP))*1;
                        Iw(iPos(ii+1),jPos(ii+1)) = I(iPos(ii+1),jPos(ii+1)) + sign(errorY(iP))*1;
                    end
            end
            continue
        end
        
        
        
    end
    %
end

dis = sum(sum(abs(Iw-I)));

% ps = 10*log10(255^2*d1*d2/MSE);


end