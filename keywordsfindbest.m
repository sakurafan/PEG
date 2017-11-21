function m=keywordsfindbest(topNdocs)
load hyperclasPapers.mat;
load distribution_K=15.mat
load all.mat;

index=b1(1:150);
Community=cell(15,1);
for i=1:15
    Community{i}=[];
end
for i=1:length(index)
    com=find(distribution(index(i),:)>0.2);
    for j=1:length(com)
        Community{com(j)}=[Community{com(j)},index(i)];
    end
end
chainNum=0;

for i=1:15
    if(length(Community{i})>topNdocs)
        Community{i}=Community{i}(1:topNdocs);
        chainNum=chainNum+1;
    end
end

m=cell(chainNum,1);
matDate=cell2mat(date(:,1));
j=1;
topNwods=50;
theta=0.2;
beta=1;
type='aaa';
for i=1:15
    
    if(length(Community{i})>=topNdocs)
        candidataPapers=Community{i};
        m{j}=keywordloop(topNdocs,candidataPapers,doc2wod,wod2doc,topNwods,theta,type,beta,matDate); 
       m{j}(:,1)=-m{j}(:,1);
       j=j+1;
    end
end
end


function m=keywordloop(topNdocs,idx,doc2wod,wod2doc,topNwods,theta,type,beta,matDate)
%     m=zeros(topNdocs*(topNdocs-1)*(topNdocs-2)*(topNdocs-3)/24,6);
   m=zeros(topNdocs*(topNdocs-1)*(topNdocs-2)*(topNdocs-3)*(topNdocs-4)/120,7);
     tc=1;
     count=0;
    for i=1:topNdocs
        %tic;
        for j=i+1:topNdocs
            for k=j+1:topNdocs
                for l=k+1:topNdocs
                    for r=l+1:topNdocs
                        count=count+1;
                        idx_docs=[idx(i),idx(j),idx(k),idx(l),idx(r)];
    %                        idx_docs=[idx(i),idx(j),idx(k),idx(l)];
                        [paperIndx,oidx]=sort(matDate(idx_docs));%sortrows(date(idx_docs,:) ,1);
                        if(paperIndx(1)<paperIndx(2) && paperIndx(2)<paperIndx(3) && paperIndx(3)<paperIndx(4) &&paperIndx(4)<paperIndx(5))
                        idx_docs= idx_docs(oidx);
                        [~,fval,~,exitflag]=all_complicate_topic_run( idx_docs,doc2wod,wod2doc,topNwods,theta,type,beta);  
                        m(tc,:)=[fval,idx_docs,exitflag];
                         tc=tc+1;
                        end
                         if (mod(count,10)==0)
                         fprintf('%d\n',count);
                         end
                   end
                end
                        
            end
        end
        %toc;
    end 
     m=sortrows(m,1);
end

