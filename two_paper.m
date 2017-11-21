clear;
% [m,t]=two_paper_find_best(3114,3597,20,50,0.2,1,'aaa');
%for example, [m,t]=one_paper_find_best(3114,222,20,50,0.2,1,'aaa')
[m,mWord,mTfidf,t]=two_paper_find_best_with_importance(3114,3597,100,50,0.2,1,'aaa');