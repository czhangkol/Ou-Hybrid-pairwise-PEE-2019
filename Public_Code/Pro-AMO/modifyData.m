clear all
clc

load ZWM
load ProT_complete


for img = 1:8    
    performance(2*img,:) = 0;
end

for img = 1:8    
    
    len = sum(performance(2*img-1,:) > 0);
    len2 = sum(ZWM(2*img-1,:) > 0);
    
    performance(2*img-1:2*img,1) = ZWM(2*img-1:2*img,1);
    
    for i = 2:len
        real_Cap = performance(2*img-1,i);
        [~,ind] = find(ZWM(2*img-1,2:len2)>= real_Cap,1,'first');
        ind = ind + 1;
        
        [~,ind2] = find(ZWM(2*img-1,1:len2)< real_Cap,1,'last');

        
        pre_Cap = ZWM(2*img-1,ind2);
%         sub_Cap = ZWM(2*img-1,ind+1);
        cur_Cap = ZWM(2*img-1,ind);
        pre_PSNR = ZWM(2*img,ind2);
%         sub_PSNR = ZWM(2*img,ind+1);
        cur_PSNR = ZWM(2*img,ind);
        if cur_Cap > real_Cap
            performance(2*img,i) = (pre_PSNR*(cur_Cap-real_Cap)+cur_PSNR*(real_Cap-pre_Cap))/(cur_Cap-pre_Cap);
        end
    end
    
end