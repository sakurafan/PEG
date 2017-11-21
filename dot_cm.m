function [m,t]= dot_cm( dot_idx,topNdocs,topNwods,theta)
% m 输出 
% t 运行时间
% dot_idx 文章序号
%topNdocs 20 or 50 搜索范围
% topNwods 词集大小
%theta 线性规划参数   
    load all.mat;
%     load docTopN;
    load doc2doc.mat 
    load  ../../tensor/result/cr.mat;          
    
    dot_p=find(cm_p(dot_idx,:)>0);
    cluster=length(dot_p);
    dot_dx=cm_dx(dot_idx,1:cluster);
    
    matDate=cell2mat(date(:,1));  
%     docs=doc2doc(2,:);
    
    docs=doc2doc(dot_idx,:);
    
    type=3;%选择开始和结束点最相关的词
    beta=1;  
    m=cell(cluster,1);
    t=zeros(cluster,1);
    
    for i=1:cluster       
         idxss=tid{dot_dx(i),1};
         [~,idx]=sort(docs(idxss),'descend');
        idx=idxss(idx);%(:,1:topNdocs*10);
       % idx=idx(1:end);  
        idx(find(idx==dot_idx))=[];
        idx=unique(idx,'stable');    

        idx=idx(1:topNdocs);
    
        tc=tic;
        m{i}=loop_3(topNdocs,dot_idx,idx,doc2wod,wod2doc,topNwods,theta,type,beta,matDate);  
        m{i}(:,1)=-m{i}(:,1);
        t(i)=toc(tc);        
    end   
 save('dot_result','m','t');
end

function m=loop_2(topNdocs,dot_idx,idx,doc2wod,wod2doc,topNwods,theta,type,beta,matDate)
    m=zeros(topNdocs*(topNdocs-1)/2,5);
     tc=1;
    for i=1:topNdocs
        %tic;
        for j=i+1:topNdocs           
                idx_docs=[dot_idx,idx(i),idx(j)];
                [~,oidx]=sort(matDate(idx_docs));%sortrows(date(idx_docs,:) ,1);
                idx_docs= idx_docs(oidx);
                [~,fval,~,exitflag]=all_complicate_topic_run( idx_docs,doc2wod,wod2doc,topNwods,theta,type,beta);  
                [dd,~]=sort(idx_docs);
                m(tc,:)=[fval,dd,exitflag];
                 tc=tc+1;           
        end
        %toc;
    end 
     m=sortrows(m,1);
end
function m=loop_3(topNdocs,p,idx,doc2wod,wod2doc,topNwods,theta,type,beta,matDate)
    m=zeros(topNdocs*(topNdocs-1)*(topNdocs-2)/6,6);
     tc=1;
    for i=1:topNdocs
        %tic;
        for j=i+1:topNdocs
            for k=j+1:topNdocs
                idx_docs=[p,idx(i),idx(j),idx(k)];
                [~,oidx]=sort(matDate(idx_docs));%sortrows(date(idx_docs,:) ,1);
                idx_docs= idx_docs(oidx);
                [~,fval,~,exitflag]=all_complicate_topic_run( idx_docs,doc2wod,wod2doc,topNwods,theta,type,beta);  
                [dd,~]=sort(idx_docs);
                m(tc,:)=[fval,dd,exitflag];
                 tc=tc+1;
            end
        end
        %toc;
    end 
     m=sortrows(m,1);
end