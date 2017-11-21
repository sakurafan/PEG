function idx=searchWord(query)
    load word.mat
    query=lower(query);
    idx = [];
    for i=1:length(word)
        if (regexp(query,word{i}) == 1)
            idx = [idx, i];
        end
    end
end