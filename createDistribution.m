function distribution = createDistribution( U, S )
    distribution = cell([3,1]);
    for i = 1:length(U)

        p = bsxfun(@times,U{i},S');
        psum=sum(p,2);
        distribution{i}=bsxfun(@rdivide,p,psum);
    end
end

