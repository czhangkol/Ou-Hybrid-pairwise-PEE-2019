clear all
clc


imgdir = dir(['*.bmp']);
performance = zeros(length(imgdir)*2,100);
SSIMper = zeros(size(performance));
location_map = zeros(length(imgdir),100);
re = zeros(length(imgdir)*2,9);


mapList = GenList; % generate the mapping of pairwise PEE
 
 
    
    
for i_img = [7]
    i_img
    img = 2*(i_img-1)+1;
    I = double(imread([imgdir(i_img).name]));
    
    nIndex = 1;
    I_or = I;
    [bin_LM,bin_LM_len,I] = LocationMap(I);
    [d1,d2] = size(I);
    
    
    for Capacity = 512^2*0.1+bin_LM_len:1000:512^2*0.1+bin_LM_len
       tic
        Capacity
        dis2 = 0;
        half = Capacity*0.5;
        %----------------cross layer
        tic
        [BestOut,BestIn,BestECm,BestEDm,T1] = Adptive2D_1st(I,mapList,half);
 
%         T1 = 17;

        if T1 == -1
            break
        end
%         T1 = 9999;
%         T2 = 16;
        %------ pixel prediction, ED is the shifting distortion for the prediction-error e >1 and e < -2
        [Ex,Ey,~,xpos,ypos,pFor,MSE0,Iw] = prediction_H(I,half,T1,BestECm,BestEDm);
        dis2 = dis2 + MSE0;
            
        
        %------data embedding
         [Iw, nBit, MSE,MSE2] = singleLayerEmbedding_H(Iw, half, pFor, Ex, Ey, xpos, ypos,BestOut);
        dis2 = dis2 + MSE;
        nBit1 = nBit;
        performance(img,nIndex) = performance(img,nIndex)  + nBit;
        

        %----------------blank layer
        
        [BestOut2,BestIn2,BestECm2,BestEDm2,T2] = Adptive2D_2nd(Iw,mapList,half);
       
        if T2 == -1
            performance(img,nIndex) = 0;
            break
        end
        
%         T1 = 9999;
        
        %------ pixel prediction, ED is the shifting distortion for the prediction-error e >1 and e < -2
        [Ex,Ey,~,xpos,ypos,pFor,MSE0,Iw] = prediction2_H(Iw,half,T2,BestECm2,BestEDm2);
        dis2 = dis2 + MSE0;
        
        %------data embedding
        [Iw, nBit, MSE,MSE2] = singleLayerEmbedding_H(Iw, half, pFor, Ex, Ey, xpos, ypos,BestOut2);
        dis2 = dis2 + MSE;
        performance(img,nIndex) = performance(img,nIndex)  + nBit - bin_LM_len;
 
        dis = sum(sum(abs(I_or-Iw).^2));
 
        if performance(img,nIndex) < Capacity - bin_LM_len
            performance(img,nIndex) = 0;
            break
        end
        
        
        performance(img+1,nIndex) = 10*log10(255^2*d1*d2/dis);
 
        nIndex = nIndex + 1;
         toc
    end

    
end
 

