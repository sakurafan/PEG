function  [m,mWord,t]=one_paper_find_best_with_important(p,topNdocs,topNwods,theta,beta,community_type)

load all.mat
load pagerank.mat %paper importance computed by hits algorithm, saved in ptopx
candidataPapers=find_candidate(p,community_type,topNdocs);
chainNum=size(candidataPapers,1);
type=3;
start=tic;
mWord=cell(1,topNdocs*(topNdocs-1)*(topNdocs-2)*(topNdocs-3)/24);
m=cell(chainNum,1);
for i=1:chainNum
    [m{i},mWord{i}]=loop_4(topNdocs,p,candidataPapers{i},doc2wod,wod2doc,topNwods,theta,type,beta,paperDate,ptopx); 
    m{i}(:,1)=-m{i}(:,1);
end

t=toc(start);


end

function [m,mWord]=loop_4(topNdocs,sp,idx,doc2wod,wod2doc,topNwods,theta,type,beta,paperDate,ptopx)
    m=zeros(topNdocs*(topNdocs-1)*(topNdocs-2)*(topNdocs-3)/24,7);
    
    tc=1;
    delta =  median(ptopx);
%     delta = prctile(ptopx,75);
    for i=1:topNdocs
        %tic;
        if ptopx(idx(i)) < delta
            continue;
        end
        for j=i+1:topNdocs
            if ptopx(idx(j)) < delta
                continue;
            end
            for k=j+1:topNdocs
                if ptopx(idx(k)) < delta
                    continue;
                end
                for l=k+1:topNdocs
                    if ptopx(idx(l)) < delta
                        continue;
                    end
                    idx_docs=[sp,idx(i),idx(j),idx(k),idx(l)];
                    [~,oidx]=sort(paperDate(idx_docs));%sortrows(date(idx_docs,:) ,1);
                    idx_docs= idx_docs(oidx);
                    [influentWord,fval,~,exitflag]=all_complicate_topic_run( idx_docs,doc2wod,wod2doc,topNwods,theta,type,beta);  
                    m(tc,:)=[fval,idx_docs,exitflag];
                    mWord{tc}=influentWord;
                    tc=tc+1;
                end                    
            end
        end
        %toc;
    end 
     m=sortrows(m,1);
end