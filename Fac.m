% DEMO_METAFAC - demonstrate the metafac algorithm
% See also METAFAC

% Author: Yu-Ru Lin <yu-ru.lin@asu.edu>, August 2008
clc;
clear;
load('author.mat')
load('refer.mat')
load('tfidf.mat')
fprintf('\nDemo MetaFac algorithm...');
clear RG; clear Vdims;
K = 15; % no. of factors (or clusters)
prior={}; % test without prior
w1=0.2; % test with equal weights for all relations

fprintf('\n => generate 3-order data tensor for R1');
[row,col]=find(referTotal~=0);
sz=size(referTotal);
refer1=sptensor([row,col],1,sz);
RG{1} = {refer1,1:1,w1};
Vdims = [size(refer1,1)];%1000*1000*1000
% Vdims,RG
% fprintf('\n => run MetaFac for R1');
% [S,U,iters,cvtime]=metafac(RG, Vdims, K, prior);

% fprintf('\n => generate 2-order data tensor for R2 (which shares 1st entity with R1)');

[row,col]=find(tfidf~=0);
sz=size(tfidf);
tfidf1=sptensor([row,col],1,sz);
w2=0.2;
RG{2} = {tfidf1,[1 length(Vdims)+1],w2};
Vdims = [Vdims size(tfidf1,2)];
% Vdims,RG
fprintf('\n => run MetaFac for R12');
% [S,U,iters,cvtime]=metafac(RG, Vdims, K, prior);

% fprintf('\n => generate 2-order data tensor for R3 (which shares 2nd entity with R1)');
[row,col]=find(paper2author~=0);
sz=size(paper2author);
publications1=sptensor([row,col],1,sz);
w3=0.6;
RG{3} = {publications1,[1 length(Vdims)+1],w3};
Vdims = [Vdims size(publications1,2)];
% Vdims,RG
fprintf('\n => run MetaFac for R123');
[S,U,iters,cvtime]=metafac(RG, Vdims, K, prior);

