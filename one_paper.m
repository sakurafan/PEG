clear;
clc;
% [m,t]=one_paper_find_best(962,20,50,0.2,1,'aaa');

[m,mword,t]=one_paper_find_best_with_important(3367,50,50,0.2,1,'aaa');
% [m,t]=one_paper_find_best_with_important(5530,50,50,0.2,1,'aaa');
%for example, [m,t]=one_paper_find_best(3114,20,50,0.2,1,'aaa')
load('all.mat','titles');
titles{m{1,1}(1,2:6)}
% titles{m{2,1}(1,2:6)}