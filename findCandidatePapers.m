function paperIdx=findCandidatePapers(query, k)
%   k 是选择的tfidf最大的论文数
%
    load 'tfidf.mat'
    query=lower(query);
    query=deblank(query);
    word = regexp(query, ' ', 'split');
    paperCandidate=zeros(size(tfidf,1),1);
    for i=1:length(word)
        idx = searchWord(word{i});
        for j=1:length(idx)
            paperCandidate = paperCandidate + tfidf(:,idx(j));
        end
    end
    % 如果存在一个元素不为0
    if any(paperCandidate) == 1
        [~, paperIdx] = sort(paperCandidate, 'descend');
        paperIdx=paperIdx(1:k,:);
    else
        paperIdx = [];
    end
end