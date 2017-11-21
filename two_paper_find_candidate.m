function candidatePapers=two_paper_find_candidate(paper_index1,paper_index2,community_type,topNdocs)
% paperNum=6395;
paperNum=24491;
threshold=0.2;
% 
%      load (['distribution_',community_type,'_K=30','.mat']);
%      load (['Community_member_',community_type,'_K=30','.mat']);

%      load (['distribution_K=15','.mat']);
%      load (['Community_member_K=15','.mat']);
    load (['distribution_paper','.mat']);
    load (['Community_member_paper','.mat']);
    load simMatrix.mat
    load('all.mat', 'paperDate')
    distribution_p1=distribution(paper_index1,:);
    distribution_p2=distribution(paper_index2,:);
    comIdx1=find(distribution_p1>threshold);
    comIdx2=find(distribution_p2>threshold);
%     comIdx=[8,14];
    comIdx=[comIdx1,comIdx2];
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

vector1=matrix(paper_index1,:);
vector2=matrix(paper_index2,:);
vector=vector1.*vector2;
 %--------------------------------------------           
            [~,idx]=sort(vector,'descend');
        for k=1:comNum
%              ComMember{k}=Community_member{comIdx(k)};
            ComMember{k}=Community_member_paper{comIdx(k)};
            for lth=1:length(ComMember{k})
                if(paperDate(ComMember{k}(lth))<paperDate(paper_index1) || paperDate(ComMember{k}(lth))>paperDate(paper_index2))
                    ComMember{k}(lth)=0;
                end
            end
            ComMember{k}(find(ComMember{k})==0)=[];
%             ComMember{k}=Community_member_author{comIdx(k)};           %%author type
%             ComMember{k}=Community_member_word{comIdx(k)};
%               ComMember{k}=Community_member_paper{comIdx(k)};
            count=0;
            for i=1:paperNum

                    if(any(ComMember{k}==idx(i)))
                        count=count+1;
                        candidatePapers{k}(count)=idx(i);
                    end
                    if(count>topNdocs)
                        break;
                    end

            end
            idx_temp1=find(candidatePapers{k}==paper_index1);
            
            candidatePapers{k}(idx_temp1)=[];
            idx_temp2=find(candidatePapers{k}==paper_index2);
            candidatePapers{k}(idx_temp2)=[];


        end

         
    
end
