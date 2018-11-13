%% drawing band show of realdata HSI to make comparison
%%
%   1. NLM3D
%   2. BM4D
%   3. LRTA
%   4. PARAFAC
%   5. TensorDL
%   6. CMESSC
%   7. Ours
close all;
clear;
clc;
%BANDNUMBER=[68,29,2;50,36,15];
%BANDNUMBER1=[3,110,218;2,103,192];
%data_name_1={'PaviaU';'Wdc'};
data_name={'Indiana';'Urban'};
%NOISE='GSforBand';
DATABASE='realdata';
number_of_image=2;
number_of_noiseband=1;
METHODNUMBER=7;
%COL=[145,200];ROW=[145,200];
METHODNAME={'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
METHODNAME_M={'ORI';'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
PSNR=0.11;
%% real data 
for NI=1:number_of_image
for NB=1:number_of_noiseband

%DATA{1}=load(['./Ours/noiseimage/',DATABASE,'_',num2str(NI),'_SHOW_P','.mat']);%DATA{1}=load(['./Ours/groundtruth/',DATABASE,'_',num2str(NI),'.mat']);
%DATA{1}=DATA{1}.DO;
DATA{1}=load(['./NoiseImage/',DATABASE,'_',num2str(NI),'.mat']);
DATA{1}=DATA{1}.DO;
for M=1:7
%DATA{M+1}=load(['./',METHODNAME{M},'/pcolor/',METHODNAME{M},'_',DATABASE,num2str(NI),'_',num2str(PSNR),'_SHOW_P','.mat']);
DATA{M+1}=load(['./',METHODNAME{M},'/pcolor/',METHODNAME{M},'_',DATABASE,num2str(NI),'_',num2str(PSNR(NB)),'.mat']);
DATA{M+1}=DATA{M+1}.IM;
end

for BAND=1:3
%METHODNAME_MM={'Noisy band ' ;'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
new_folder = ['.\fig_of_comp\',DATABASE,'_',num2str(NI),'_',num2str(PSNR(NB)),'_BAND',num2str(BAND)]; 
mkdir(new_folder);  % mkdir()函数创建文件夹figure(1);
for M=1:8
%HP=subplot(1,4,M);
%reset(H);
figure(1);
imshow(DATA{M}(:,:,BAND),[]);
FILENAME=[new_folder,'\',METHODNAME_M{M},'_',DATABASE,'_',num2str(NI),'_','_BAND',num2str(BAND),'.pdf'];
export_fig (FILENAME);
%saveas(1,FILENAME);
end
end
end
end