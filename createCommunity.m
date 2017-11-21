function community = createCommunity( distribution, threshold )
if nargin < 2
    threshold = 0.2;
end
K = 15; %community num
community = cell([K,3]);

for i = 1:length(distribution)
    for j = 1:K
        [rows,~] = find(distribution{i}(:,j)>threshold);
        community{j,i}=rows';
    end
end


end