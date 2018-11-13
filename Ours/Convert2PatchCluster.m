function [GrouPatch,lenSel,par,rzSize,sizeLi,MEM] = Convert2PatchCluster(RZ,par)
% =========================================================================
% Covert 3D HSI to clusters of patches
% =========================================================================
% INPUT ARGUMENTS:
% rX           noisy observation matrix of 3D HSI 
% par          cluster number & patch parameter
% =========================================================================
% OUTPUT ARGUMENTS:
% GrouPatch           clusters of patches of HSI,each cell is a cluster
% lenSel              cluster number
% par                 parameters of patch dividing
% rzSize              row and col of the input HSI
% sizeLi              size of divided patches,sizeLi(1) is patch size(s*s),
%                     sizeLi(2) is band number,sizeLi(3) is patch number              
% MEM                 patch index in each cluster
% =========================================================================
addpath(genpath('mylib'));
addpath(genpath('tc_codes'));
addpath(genpath('libZhao'));
addpath(genpath('libDong'));
%addpath(genpath('STDC'));
%addpath(genpath('TMAC'));
addpath(genpath('./tensor_toolbox'));%_2.6
%time0 = clock;
%%
%Pos = [1, 1];
%w = 512;
%RZ = RZ(Pos(1) : Pos(1) + w - 1,Pos (2) : Pos(2) + w - 1,:);  
%[Sel_arr]       =  nonLocal_arr(rzSize, par); % PreCompute the all the keypatch index in the searching window 
%lenSel               =   length(Sel_arr);
     rzSize = size(RZ);
     uGrpPatchs = Im2Patch3D(RZ,par);%Covert 3D HSI to many patches
     sizeLi=size(uGrpPatchs);
     uGPTOPixel=CovertTo2D(uGrpPatchs)';%Covert all 3D patches to a 2D matrix,each col is a patch
     [LIndex,C] = kmeansPlus(uGPTOPixel,par.NumOfCluster);% k-means cluster
     [~,lenSel]=size(C);
     MEM=cell(lenSel);
     [~,Ln]=size(LIndex);
     for h=1:Ln
        c=LIndex(h);
        MEM{c}=[MEM{c} h];
     end
     GrouPatch=cell(lenSel);
     for r = 1 :lenSel
     Medium=uGPTOPixel(:,MEM{r});
     GrouPatch{r}=Medium;% give patches to each cluster
     end
        %F_k=GrouPatch(:,:,r);
        %X_k0 = GrouPatch0(:,:,r);
     %uGrpPatchs2 = Im2Patch3D(Z3d0,par);
     %sizeLi = size(uGrpPatchs);
%     
%     % block matching to find samilar FBP goups
     %unfoldPatch     = Unfold(uGrpPatchs,sizeLi,3)';
     %patchXpatch     = sum(unfoldPatch.*unfoldPatch,1);
     %distenMat       = repmat(patchXpatch(Sel_arr),sizeLi(3),1)+repmat(patchXpatch',1,lenSel)-2*(unfoldPatch')*unfoldPatch(:,Sel_arr);
     %[~,index]       = sort(distenMat);
     %index           = index(1:par.patnum,:);
     %clear patchXpatch distenMat;
     
     %for i = 1:lenSel
         %Groups{i} = uGrpPatchs(:,:,index(:,i));      % Groups{i}
%         Groups2{i} = uGrpPatchs2(:,:,index(:,i)); 
    %end
%     % end of block matching
     %for num=1:lenSel
         %GrouPatch(:,:,num)=CovertTo2D( Groups{num})';
     %end
     
end     

