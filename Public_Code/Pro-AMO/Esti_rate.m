function [py]=Esti_rate(px,Dxy,r,r_max,H_X)

e=0.01;
left=0;
left_rate=r_max;
right=1.3;
[py]=max_entropy_br(px,Dxy,right);
 right_rate=h(py)-H_X;
while(right_rate>r)
     right=right+0.1;
     [py]=max_entropy_br(px,Dxy,right);
     right_rate=h(py)-H_X;
end
flag=1;
if(r-right_rate<e)
    py=py;
    a=right;
elseif(left_rate-r<e)
    [py]=max_entropy_br(px,Dxy,left);
    a=left;
else
    while(flag)
        mid=left+(right-left)/2;
        [py]=max_entropy_br(px,Dxy,mid);
        mid_rate=h(py)-H_X;
        if(abs(r-mid_rate)<e)
            flag=0;
            a=mid;
        elseif(r-mid_rate>=e)
            right=mid;
        else
            left=mid;
        end
    end
end
diff=h(py)-H_X-r;
end

