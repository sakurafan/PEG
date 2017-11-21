function  [m,mWord,mTfidf,t]=two_paper_find_best_with_importance(p1,p2,topNdocs,topNwods,theta,beta,community_type)

load all.mat
load pagerank.mat %paper importance computed by hits algorithm, saved in ptopx

candidataPapers=two_paper_find_candidate(p1,p2,community_type,topNdocs+1);
chainNum=size(candidataPapers,1);
type=3;
start=tic;
m=cell(chainNum,1);
mWord=cell(chainNum,1);
mTfidf=cell(chainNum,1);
% matDate=cell2mat(date(:,1));
for i=1:chainNum
    [m{i},mWord{i},mTfidf{i}]=loop_4(length(candidataPapers{i}),p1,p2,candidataPapers{i},doc2wod,wod2doc,topNwods,theta,type,beta,paperDate,ptopx); 
    m{i}(:,1)=-m{i}(:,1);
end

t=toc(start);


end

function [m,mWord,mTfidf]=loop_4(topNdocs,p1,p2,idx,doc2wod,wod2doc,topNwods,theta,type,beta,paperDate,ptopx)
    m=zeros(topNdocs*(topNdocs-1)*(topNdocs-2)/6,7);
    mWord=cell(1,topNdocs*(topNdocs-1)*(topNdocs-2)*(topNdocs-3)/24);
    mTfidf=cell(1,topNdocs*(topNdocs-1)*(topNdocs-2)*(topNdocs-3)/24);

    tc=1;
    delta = prctile(ptopx,75);
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
                    idx_docs=[p1,p2,idx(i),idx(j),idx(k)];
                    [~,oidx]=sort(paperDate(idx_docs));%sortrows(date(idx_docs,:) ,1);
                    idx_docs= idx_docs(oidx);
                    [influentWord,word_tfidf,fval,~,exitflag]=all_complicate_topic_run( idx_docs,doc2wod,wod2doc,topNwods,theta,type,beta);  
                    m(tc,:)=[fval,idx_docs,exitflag];
                    mWord{tc}=influentWord;
                    mTfidf{tc}=word_tfidf;
                    tc=tc+1;    
            end
        end
        %toc;
    end 
     [m,index]=sortrows(m,1);
     mWord=mWord{index};
     mTfidf=mTfidf{index};
end