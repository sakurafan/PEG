function [doc2wod,wod2doc,doc2doc]=word_importance(dir,filename,storename)
    s_tfidf=load([dir,'/',filename]);
    d_trans=sparse(s_tfidf.tfidf); 
    d_trans= bsxfun(@rdivide,d_trans,sum(d_trans,2));
    d_trans(isnan(d_trans)) = 0;      %把NaN都变为0
    
    w_trans=d_trans';
    w_trans=bsxfun(@rdivide,w_trans,sum(w_trans,2));
    w_trans(isnan(w_trans)) = 0;      %把NaN都变为0
    
%     save('d_trans.mat','d_trans');
%     save('w_trans.mat','w_trans');
%     
%     d=load('d_trans.mat');
%     w=load('w_trans.mat');
%     d_trans=d.d_trans;
%     w_trans=w.w_trans;
%     clear('d','w');
%     
    ndocs=size(d_trans,1);
    nwods=size(d_trans,2);

    topDoc = 50;
    topWord = 50;
    doc2wod=spalloc(ndocs,nwods,ndocs*topWord);
    doc2doc=spalloc(ndocs,ndocs,ndocs*topDoc);
%     doc2wod=zeros(ndocs,nwods);  
%     doc2doc=zeros(ndocs,ndocs);
    
    tic;
    for restart=1:ndocs    
%        tic;
        x=randwalk_multi(d_trans,w_trans,restart);
        [y1,idx1]=sort(x(1:ndocs),'descend');
%         doc2doc(restart,:)=x(1:ndocs);
        doc2doc(restart,idx1(1:topDoc))=y1(1:topDoc);
        [y2,idx2]=sort(x(ndocs+1:end),'descend');
%         doc2wod(restart,:)=x(ndocs+1:end);   
        doc2wod(restart,idx2(1:topWord))=y2(1:topWord);
%         toc;
    end
    toc;
    
    %save('im1.mat','doc2wod');
    tic;
%     wod2doc=zeros(nwods,ndocs);
    wod2doc=sparse(nwods,ndocs);
    for restart=1:nwods
%         tic;
        x=randwalk_multi(d_trans,w_trans,restart+ndocs);
        [y1,idx1]=sort(x(1:ndocs),'descend');
%         wod2doc(restart,:)=x(1:ndocs)/max(x);
        wod2doc(restart,idx1(1:topDoc))=y1(1:topDoc)/max(x);
        
%         toc;
    end   
    toc;    
    save(storename,'doc2wod','wod2doc','doc2doc');
    
end

