function [ y ] = h( x )
        x(x<eps) = eps;
        x(x>1-eps) = 1-eps;
        [u,v]=size(x);
        n=max(u,v);
        y=0;
        for i=1:n
        y = y-x(i)*log2(x(i));
 end