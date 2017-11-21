function [influentialWord,word_tfidf,fval,widx,exitflag]=all_complicate_topic_run( doc_idx,doc2wod,wod2doc,topN,theta,type,beta)    
%     tic;    
    if nargin==5
        type=2;beta=1;
    elseif nargin==6
        beta=1;
    end        
    
    [nwods,ntrans,widx,infulence]=initialize(doc_idx,doc2wod,wod2doc,topN,type);

 [f,A,b,Aeq,beq,lb,ub] = complicate_topic_condition(ntrans,nwods,infulence(:,widx),theta ,beta); 

   [x,fval,exitflag,~,~]= linprog(f,A,b,Aeq,beq,lb,ub) ;
   if(exitflag~=1)
       fprintf('programing got wrong answer\n');
   end
   pw=reshape(x(1:end-1),nwods,ntrans);
   [word_tfidf,iidx]=sort(pw,1,'descend');
   % top 5 words important
   iidx=iidx(1:5,:);
   influentialWord=widx(iidx);
   word_tfidf=word_tfidf(1:5,:);
%    toc;
    
end
function [nwods,ntrans,idx,infulence]=initialize(doc_idx,doc2wod,wod2doc,topN,type)
    doc=doc2wod(doc_idx,:);
    clear doc2wod;

    word=wod2doc(:,doc_idx);  %取链中论文对应的词的影响力
    clear wod2doc;

   ntrans=length(doc_idx)-1;%n篇文章、则n-1个转移，这里指转移
     nwods=size(word,1);
    infulence=zeros(ntrans,nwods);
    for i=1:ntrans
      infulence(i,:)=doc(i,:).*word(:,i+1)';
    end
    switch(type)
        case 1
    % 1     %所有文章到词的概率最大
          idx=zeros(ntrans,nwods);
          for i=1:ntrans+1
              [~,idx(i,:)]=sort(doc(i,:),'descend');
          end
          idx=idx(:,1:topN);
          idx=idx(1:end);     
          idx=unique(idx,'stable');
    
        %  idx=idx(1:topN);
          nwods=length(idx);%idx=[1:nwods];
       case 2
      % 2  %取转移概率概率最高
          idx=zeros(ntrans,nwods);
          for i=1:ntrans
              [~,idx(i,:)]=sort(infulence(i,:),'descend');
          end
          idx=idx(:,1:topN);
          idx=idx(1:end);     
          idx=unique(idx,'stable');

        %  idx=idx(1:topN);
          nwods=length(idx);%idx=[1:nwods];
        case 3
    %    3  %取开始和结束文章概率最大
          idx=zeros(2,nwods);      
          %这里记录要选择的词
          [~,idx(1,:)]=sort(doc(1,:),'descend');
          [~,idx(2,:)]=sort(doc(end,:),'descend');
          idx=idx(:,1:topN*2);
          idx=idx(1:end);     % convert to vector
          idx=unique(idx,'stable'); % 除去重复的词
          nwods=length(idx);
        otherwise
            idx=1:nwods;
      end
 
end

function [f,A,b,Aeq,beq,lb,ub]=complicate_topic_condition(ntrans,nwods,influence,theta,beta)
    TN=ntrans*nwods;
    vlen=ntrans*nwods+1;
    
    %max: minedge
    f=sparse(1,vlen);
    f(end)=-1;
    
    %init 
    %|p(w,i)-p(w-1,i)|<=theta
%     ws=sparse(TN*2-nwods,vlen);%result is a (2*TN-nwods) * vlen Matrix       
%     ws(1:TN,1:TN)=sparse(1:TN,1:TN,1)+diag(-sparse(ones(TN-nwods,1)),-nwods);%小于式
%     ws(TN+1:end,:)=-ws(nwods+1:TN,:);
%     bs=theta*ones(2*TN-nwods,1);%( 2*TN-nwods vector ) right-value

    ws=sparse(2*(TN-nwods),vlen);%result is a (2*TN-nwods) * vlen Matrix       
    ws(1:TN-nwods,1:TN-nwods)=sparse(1:TN-nwods,1:TN-nwods,1);
    ws(1:TN-nwods,nwods+1:end-1)= ws(1:TN-nwods,nwods+1:end-1)-sparse(1:TN-nwods,1:TN-nwods,1);
    ws(TN-nwods+1:end,:)=-ws(1:TN-nwods,:);
    bs=theta*ones(2*(TN-nwods),1);%( 2*TN-nwods vector ) right-value

    %condition 
    %sum|w p(w,i)<=1 
    %change to equal
    I=sparse(1,ntrans*nwods);
    for i=1:ntrans    
       I((i-1)*nwods+1:i*nwods)=i;
    end
    J=1:TN;
    wa=sparse(I,J,1,ntrans,vlen);
    ba=ones(ntrans,1);%( ntrans*1 Matrix ) left-value
    
%     Aeq=wa;
%     beq=ba;
    Aeq=[];
    beq=[];
    
    %objective
    % minedge- w_sum<=0
    %influence is ntrans*nwods Matrix   

    wobj=sparse(ntrans,vlen);
    for i=1:ntrans
        wobj(i,nwods*(i-1)+1:nwods*i)=-influence(i,:);
    end
    wobj(:,end)=ones(ntrans,1);
    bobj=sparse(ntrans,1);
    
    A=[ws;wobj;wa];%];%
    b=[bs;bobj;ba];%];%;ba
 
    %low-upon bound
    lb=sparse(vlen,1);
    ub=beta*ones(vlen,1);
 end