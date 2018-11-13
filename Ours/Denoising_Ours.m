function [rX] = Denoising_Ours(rX,row,col,STEP,CLUSTER)
% =========================================================================
% Denoising Hyperspectral Image Using Our Algorithm
% =========================================================================
% INPUT ARGUMENTS:
% rX        noisy observation matrix of size nb * np, np = row * col, nb denotes the number of bands. 
% row       row number of each band
% col       column number of each band.
% STEP      pact hsize (s*s)
% CLUSTER   cluster number
% =========================================================================
% OUTPUT ARGUMENTS:
% rX        estimated clean image of size nb * np.
% =========================================================================
rand('seed',0);
randn('seed',0);
%% Preprocessing
[nb,np] = size(rX);
complete = 0;                                      % dictionary type: 1 denotes orthogornal DWT dictionary, 0 denotes the over-complete DCT dictionary
if complete                                        % generate spectrum dictionary
    D = OrthogonalDWT(nb);
else
    D = creatOvercompleteDCT(nb,nb * 2,1);
end
rX = HCS_RLPHCS(eye(nb), D, rX); % denoising for accurate clustering;
%%

rX=CovertTo3D(rX,row,col);
%X0=CovertTo3D(X0,row,col);
%rX=CovertTo3D(rX,row,col);
%% iteration parameter
%NumOfCluster=10;%10;%10;%7;%70,75;%clusters
N=1;%20;%
T=1;%20;
beta=0.01;%0.01;%0.3;%0.13;%0.06,0.07;
%% opt parameter
opts.maxIterNum =15;%11,7;
opts.prior = true;
opts.tol = 1e-6;
opts.print = false;
rX_Saver=rX;
%% patch parameter
par = ParSet(CLUSTER,STEP);%parameters of patches
%% Outer Loop
for n = 1 : N
    %% 1.K-means Cluster
     [GrouPatch,lenSel,par,rzSize,sizeLi,MEM] = Convert2PatchCluster(rX,par);%divide HSI to patches and clustering
     PatchCluster=cell(lenSel);
     %[GrouPatch0,lenSel,par,rzSize,sizeLi,index] = Convert2Patch(X0);
    %[LIndex,C] = kmeansPlus(rX,k);
   %% 2.Low rank matrix L estimation: 
     for r = 1 : lenSel
   %% initializetion of L_k
   %%
        clear F_k L_k;
        %F_k = rX(:,MEM{r});
        F_k=GrouPatch{r};
        %X_k0 = GrouPatch0(:,:,r);
        L_k = F_k;       
   %% Inner Loop:
        
        for i = 1 : T
   %% (a)Sparse learning for rank determination
            [U,S,V]=svd(L_k,'econ');%
            s_k=diag(S);
            t_k = RLPHCS_Rec2(s_k,opts);%£¨18£©
   %% (b)get L_k
            T_k=diag(t_k);
            L_k = U * T_k * V' + beta * (F_k - L_k);
            %psnr1 = GetPSNR(X_k0,L_k);
            %psnr2 = GetPSNR(X_k0,U * T_k * V');
            %fprintf('inn = %d, Lk = %.4f, UTV = %.4f  \n', i, psnr1, psnr2);
        end
     
     PatchCluster{r}=L_k;
     end
    %% 3.HSI recontructed as X=L    
        rX =ClusterTo3D(rX_Saver,PatchCluster,lenSel,par,rzSize,sizeLi,MEM);
end
rX=CovertTo2D(rX);
end

