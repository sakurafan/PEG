function candidatePapers=find_candidate(paper_index,community_type,topNdocs)
paperNum=6395;

threshold=0.2;
% 
%      load (['distribution_',community_type,'_K=30','.mat']);
%      load (['Community_member_',community_type,'_K=30','.mat']);

     load (['distribution_paper','.mat']);
     load (['Community_member_paper','.mat']);
%       load 
     load simMatrix.mat %simmatrix = doc2wod * wod2doc
     
     %判断这篇文章属于哪几个主题
    distribution_p=distribution(paper_index,:);
    comIdx=find(distribution_p>threshold);
    comNum=length(comIdx);
    
    ComMember=cell(comNum,1);
    for i=1:comNum
        ComMember{i}=[];
    end
%     vector=zeros(1,paperNum);
%     candidatePapers=zeros(comNum,topNdocs);
    candidatePapers=cell(comNum,1);
        for i=1:comNum
            candidatePapers{i}=[];
        end
%   ----------------------similarity vector ----- 

vector=matrix(paper_index,:);
 %--------------------------------------------           
            [~,idx]=sort(vector,'descend');
        for k=1:comNum
%             ComMember{k}=Community_member{comIdx(k)};
%             ComMember{k}=Community_member_author{comIdx(k)};           %%author type
%             ComMember{k}=Community_member_word{comIdx(k)};
              ComMember{k}=Community_member_paper{comIdx(k)};
            count=0;
            for i=1:paperNum

                    if(any(ComMember{k}==idx(i)))
                        count=count+1;
                        candidatePapers{k}(count)=idx(i);  % 选取相同主题下最相近的文章
                    end
                    if(count>topNdocs)
                        break;
                    end

            end
            idx_temp=find(candidatePapers{k}==paper_index);
            candidatePapers{k}(idx_temp)=[]; %排除搜索集中与要查询论文相同的论文


        end

         
    
end
