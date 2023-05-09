function [ Py,Rav ] = max_entropy_br_dav( Ps,Dsy,Dav )
%MAX_ENTROPY_MG Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(Dsy);
%Dsy=(repmat(Ps,1,n)).*Dsy;

MPs=repmat(Ps,1,n);
Dsy=MPs.*Dsy;

%Dav=Dav+eps;
if Dav <= 1e-5
    Dav=1e-5;
end

%parameters
MAXITERS=200;
STol=1e-3;
Tol=1e-3;
NTTol=1e-6;
MU=20;
Alpha=0.01;
Beta=0.5;

%
x=zeros(n+m+1,1)+0.1;
t=1;
step=1;
for iters=1:MAXITERS
    %
    Mfx=Dsy*x(n+m+1)+repmat(x(n+1:n+m),1,n)+Ps*(x(1:n)');
    fx=[Mfx(:);x(n+m+1)];
    %
    val=t*(sum(exp(x(1:n)-1))+sum(x(n+1:n+m))+Dav*x(n+m+1))-sum(log(fx));
    grad=t*([exp(x(1:n)-1);ones(m,1);Dav])-[(sum(MPs./Mfx))';sum(1./Mfx,2);sum(sum(Dsy./Mfx))+1/x(n+m+1)];
    %{
    Hf0=[diag(exp(x(1:n)-1)),zeros(n,m+1);zeros(m+1,m+n+1)];
    Hfx=[-diag(sum((MPs./Mfx).^2))  , -(MPs./(Mfx.^2))',            -(sum((Dsy.*MPs)./(Mfx.^2)))'; ...
         -(MPs./(Mfx.^2))           , -diag(sum(1./(Mfx.^2),2)),    -sum(Dsy./(Mfx.^2),2);         ...
         -sum((Dsy.*MPs)./(Mfx.^2)) , -(sum(Dsy./(Mfx.^2),2))',     -sum(sum((Dsy./Mfx).^2))-1/(x(n+m+1)^2)];         
    hess=t*Hf0-Hfx;
    %
    Dx=-hess\grad;
    %}
    %disp(iters);
    Dx=fast_linear_solver(t*exp(x(1:n)-1)+(sum((MPs./Mfx).^2))',[(MPs./(Mfx.^2))',(sum((Dsy.*MPs)./(Mfx.^2)))'],[diag(sum(1./(Mfx.^2),2)),sum(Dsy./(Mfx.^2),2);(sum(Dsy./(Mfx.^2),2))',sum(sum((Dsy./Mfx).^2))+1/(x(n+m+1)^2)],-grad);
    fprime=grad'*Dx;
    
    %
    if( (-fprime < NTTol) || (step <= STol))
        gap=(m*n+1)/t;
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
    Dff=Dsy*Dx(n+m+1)+repmat(Dx(n+1:n+m),1,n)+Ps*(Dx(1:n)');Dff=[Dff(:);Dx(n+m+1)];
    while (min(fx+step*Dff)<=0)
        step=Beta*step;
    end
    
    newx=x+step*Dx;
    newfx=Dsy*newx(n+m+1)+repmat(newx(n+1:n+m),1,n)+Ps*(newx(1:n)');newfx=[newfx(:);newx(n+m+1)];
    while ( (t*(sum(exp(newx(1:n)-1))+sum(newx(n+1:n+m))+Dav*newx(n+m+1))-sum(log(newfx))) > (val+Alpha*step*fprime) )
        step=Beta*step;
        newx=x+step*Dx;
        newfx=Dsy*newx(n+m+1)+repmat(newx(n+1:n+m),1,n)+Ps*(newx(1:n)');newfx=[newfx(:);newx(n+m+1)];
    end  
    
    x=x+step*Dx;
    
end
%disp(iters);
%
Py=exp(x(1:n)-1);
Rav=x(n+m+1);
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