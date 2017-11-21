function x= randwalk_multi(d_trans,w_trans,restart)   
    ndocs=size(d_trans,1);
    nwods=size(d_trans,2);
    lamd=0.1;
%     x=init_start(restart,ndocs,nwods,x_in) ; 
    x=zeros(1,ndocs+nwods);
    x(restart)=1;

    x_old=x;
    
    while(1)    
        x(ndocs+1:end)=(1-lamd)*x_old(1:ndocs)*d_trans;  
        x(1:ndocs)=(1-lamd)*x_old(ndocs+1:end)*w_trans;                      
        x(restart)=x(restart)+lamd; 
        if(norm(x-x_old)/norm(x)<1e-13) 
            break;
        end
        x_old=x;
    end
end

