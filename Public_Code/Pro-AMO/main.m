clear all
clc

imgdir = dir(['*.bmp']);
performance = zeros(length(imgdir)*2,100);
location_map = zeros(length(imgdir),100);
re = zeros(length(imgdir)*2,9);
SSIMper = zeros(size(performance));

% load ZWM

for i_img = [7]
    i_img
    img = 2*(i_img-1)+1;
    I = double(imread([imgdir(i_img).name]));
         
    I_or = I;
    [bin_LM,bin_LM_len,I] = LocationMap(I);
    [d1,d2] = size(I);
    nIndex = 1;
 
    for Capacity = 512^2*0.1+bin_LM_len:512^2*0.1:512^2*0.1+bin_LM_len
        
        
       [Iw,dist1,ps1,dis_shift1,NL1,Qyx1] = Modi_1st(I,Capacity/2);
       ZeroPos=(Qyx1<=0.0001);
       ZeroNum=size(ZeroPos,2);
       Qyx1(ZeroPos)=0;
       [Iw,dist2,ps2,dis_shift2,NL2,Qyx2] = Modi_2nd(Iw,Capacity/2);
       ZeroPos=(Qyx2<=0.0001);
       ZeroNum=size(ZeroPos,2);
       Qyx2(ZeroPos)=0;
       dist = dist1+dist2+dis_shift1+dis_shift2;
       ps = ps1+ps2;
       psnr = 10*log10(255^2*512^2/dist);
       embedRate = ps;
       if embedRate < Capacity 
            break
       end
 
       performance(img,nIndex) = embedRate;
       performance(img+1,nIndex) = psnr;
 
       nIndex = nIndex + 1;
    end
end
 

 
