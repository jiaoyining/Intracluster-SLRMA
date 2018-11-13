
addpath(genpath('mylib'));
addpath(genpath('tc_codes'));
addpath(genpath('libZhao'));
addpath(genpath('libDong'));
%addpath(genpath('STDC'));
%addpath(genpath('TMAC'));
addpath(genpath('./tensor_toolbox'));%_2.6
time0 = clock;
%% 读数据
dataZ = load('data\RS\Wdc.mat');
% RZ = im2double(dataZ.dataZ);
RZ = dataZ.data;
%Pos = [1, 1];
%w = 512;
%RZ = RZ(Pos(1) : Pos(1) + w - 1,Pos (2) : Pos(2) + w - 1,:);     % 这里为了加速就取了左上角
rzSize = size(RZ);

sf = 8;     % 缩放因子
sz = [rzSize(1),rzSize(2)];
par = ParSet(sf,sz);
% 计算exampar patch的索引，引用自Qian Zhao代码
[Sel_arr]       =  nonLocal_arr(rzSize, par); % PreCompute the all the keypatch index in the searching window 
lenSel               =   length(Sel_arr);

%% Outer loop
V1 = zeros(rzSize(3),rzSize(1)*rzSize(2));
V2 = zeros(rzSize(3),rzSize(1)*rzSize(2));

for t = 1 : 10
    
     % 1. update L : 从Qian Zhao代码改动而来
     uGrpPatchs = Im2Patch3D(RZ,par);                    % 这里的输入需要Z是3维的形式，所以用Z3d，uGrpPatchs是划分好后所有的patch
     %uGrpPatchs2 = Im2Patch3D(Z3d0,par);
     sizeLi = size(uGrpPatchs);
%     
%     % block matching to find samilar FBP goups，取自Qian Zhao的代码
     unfoldPatch     = Unfold(uGrpPatchs,sizeLi,3)';
     patchXpatch     = sum(unfoldPatch.*unfoldPatch,1);
     distenMat       = repmat(patchXpatch(Sel_arr),sizeLi(3),1)+repmat(patchXpatch',1,lenSel)-2*(unfoldPatch')*unfoldPatch(:,Sel_arr);
     [~,index]       = sort(distenMat);
     index           = index(1:par.patnum,:);
     clear patchXpatch distenMat;
     
     for i = 1:lenSel
         Groups{i} = uGrpPatchs(:,:,index(:,i));      % Groups{i}就是一个cluster，一个cluster有40个patch，参看参数par.patnum
%         Groups2{i} = uGrpPatchs2(:,:,index(:,i)); 
    end
%     % end of block matching
     for num=1:lenSel
         GrouPatch(:,:,num)=CovertTo2D( Groups{num})';
     end
     
end     
