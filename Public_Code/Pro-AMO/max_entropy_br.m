function [ Py,Ui ] = max_entropy_br( Ps,Dsy,Rav )
%MAX_ENTROPY_MG Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(Dsy);
Dp=(repmat(Ps,1,n)).*Dsy;
Dp=Dp*Rav;

MPs=repmat(Ps,1,n);

%parameters
MAXITERS=200;
STol=1e-3;
Tol=1e-3;
NTTol=1e-6;
MU=20;
Alpha=0.01;
Beta=0.5;

%
x=zeros(n+m,1)+0.1;
t=1;
step=1;
for iters=1:MAXITERS
    %
    Mfx=Dp+repmat(x(n+1:n+m),1,n)+Ps*(x(1:n)');
    fx=Mfx(:);
    %
    val=t*(sum(exp(x(1:n)-1))+sum(x(n+1:n+m)))-sum(log(fx));
    grad=t*([exp(x(1:n)-1);ones(m,1)])-[(sum(MPs./Mfx))';sum(1./Mfx,2)];
    %{
    Hf0=[diag(exp(x(1:n)-1)),zeros(n,m);zeros(m,m+n)];
    Hfx=[-diag(sum((MPs./Mfx).^2))  , -(MPs./(Mfx.^2))'; ...
         -(MPs./(Mfx.^2))           , -diag(sum(1./(Mfx.^2),2))];         
    hess=t*Hf0-Hfx;
    Dx=-hess\grad;
    %}
    Dx=fast_linear_solver(t*exp(x(1:n)-1)+(sum((MPs./Mfx).^2))',(MPs./(Mfx.^2))',diag(sum(1./(Mfx.^2),2)),-grad);
    fprime=grad'*Dx;
    
    %
    if( (-fprime < NTTol) || (step <= STol))
        gap=m*n/t;
        if( gap < Tol )
            break;
        end
        %
        %disp(t);
        t=MU*t;
        continue;      
    end
    %
    step=1;
    Dff=repmat(Dx(n+1:n+m),1,n)+Ps*(Dx(1:n)');Dff=Dff(:);
    while (min(fx+step*Dff)<=0)
        step=Beta*step;
    end
    
    newx=x+step*Dx;
    newfx=Dp+repmat(newx(n+1:n+m),1,n)+Ps*(newx(1:n)');newfx=newfx(:);
    while ( (t*(sum(exp(newx(1:n)-1))+sum(newx(n+1:n+m)))-sum(log(newfx))) > (val+Alpha*step*fprime) )
        step=Beta*step;
        newx=x+step*Dx;
        newfx=Dp+repmat(newx(n+1:n+m),1,n)+Ps*(newx(1:n)');newfx=newfx(:);
    end  
    
    x=x+step*Dx;
    
end

%
Py=exp(x(1:n)-1);
Ui=x(n+1:n+m);
%


function [sx]=fast_linear_solver(A11,A12,A22,b)
    [sn,sm]=size(A12);
    b1=b(1:sn);
    b2=b(sn+1:sn+sm);
    
    invA11=1./A11;
    Tm=repmat(invA11',sm,1).*(A12');
    S=A22-Tm*A12;
    bs=b2-Tm*b1;
    x2=S\bs;
    x1=invA11.*(b1-A12*x2);
    sx=[x1;x2];
end


end



