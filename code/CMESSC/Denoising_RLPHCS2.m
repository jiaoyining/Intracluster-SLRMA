function [rX] = Denoising_RLPHCS2(F,complete)
% =========================================================================
%           Denoising Hyperspectral Image Using RLPHCS Algorithm
% =========================================================================
% INPUT ARGUMENTS:
% F                          noisy observation matrix of size nb * np, np = row * col, nb denotes the number of bands. 
% complete                   1 denotes with complete dictionary;
%                            0 debites using the overcomplete DCT
%                            dictionary.
% =========================================================================
% OUTPUT ARGUMENTS:
% rX                        estimated clean image of size nb * np.
% =========================================================================
% [1] Peng Y, Meng D, Xu Z, et al. Decomposable nonlocal tensor dictionary learning
%     for multispectral image denoising[C]//Computer Vision and Pattern Recognition (CVPR),
%     2014 IEEE Conference on. IEEE, 2014: 2949-2956.
% =========================================================================
[nb,np] = size(F);
sqnp = sqrt(np);
if complete
    D = (OrthogonalSR(eye(nb,nb), 'dwt', 1, nb, nb))';
else
    D = creatOvercompleteDCT(nb,nb * 4,1);
end
rX = HCS_RLPHCS(eye(nb,nb), D, F);
D = DictionaryLearning(rX);
rX = HCS_RLPHCS(eye(nb,nb), D, F);
end

function [rX] = ClusterNLM(X)
[nb,np] = size(X);
K = 20;
Flag = k_means(X',[],K);
rX = zeros(nb,np);
for k = 1 : K
    [Xk,index,nk] = SubClassExtract(X,Flag,k);
    Corr = GetCorrMatrix(Xk);
    Corr = Corr ./ repmat(sum(Corr,1),nk,1);
    rX(:,index) = Xk * Corr;
end
end

function [Corr] = GetCorrMatrix(Xk)
[nb,nk] = size(Xk);
Corr = zeros(nk,nk);
h = 0.3;
for i = 1 : nk
    for j = i + 1 : nk
        d = Xk(:,i) - Xk(:,j);
        Corr(i,j) = exp(-1.0 * d' * d / h);
        Corr(j,i) = Corr(i,j);
    end
end
end