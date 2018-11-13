%% drawing band show of RS HSI to make comparison 
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
%data_name_1={'PaviaU';'Wdc'};
%data_name_2={'Indiana';'Urban'};
NOISE='GS';
DATABASE='RS';
number_of_image=2;
if strcmp(NOISE,'GS')
number_of_noiseband=6;
else
number_of_noiseband=1;
end
METHODNUMBER=7;
%COL=[145,200];ROW=[145,200];
METHODNAME={'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
METHODNAME_M={'ORI';'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};

%% RS
%%%%
for NI=1:number_of_image
DATA{1}=load(['./groundtruth/',DATABASE,'_',num2str(NI),'.mat']);
DATA{1}=DATA{1}.DO;
for NB=1:number_of_noiseband
if number_of_noiseband==1
PSNR=0.18;
else 
PSNR=0.05*[1,2,3,4,5,6];
end
end
for M=1:7
%DATA{M+1}=load(['./',METHODNAME{M},'/pcolor/',METHODNAME{M},'_',DATABASE,num2str(NI),'_',num2str(PSNR),'_SHOW_P','.mat']);
DATA{M+1}=load(['./',METHODNAME{M},'/pcolor/',METHODNAME{M},'_',DATABASE,'_',NOISE,'_',num2str(NI),'_',num2str(PSNR(NB)),'.mat']);
DATA{M+1}=DATA{M+1}.IM;
end

for BAND=1:3
%BAND=2;
METHODNAME_MM={'Original HSI ' ;'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
new_folder = ['.\fig_of_comp\',DATABASE,'_',num2str(NI),'_',NOISE,'_',num2str(PSNR(NB)),'_BAND',num2str(BAND)]; 
mkdir(new_folder);  % mkdir()函数创建文件夹
for M=1:8

figure(1);
imshow(DATA{M}(:,:,BAND),[]);
%FILENAME=[new_folder,'\',METHODNAME_M{M},'_',DATABASE,'_',num2str(NI),'_',num2str(PSNR(NB)),'_BAND',num2str(BAND),'.pdf'];
FILENAME=[new_folder,'\',METHODNAME_M{M},'_',DATABASE,'_',num2str(NI),'_',NOISE,'_BAND',num2str(BAND),'.pdf'];
export_fig (FILENAME)
%saveas(1,FILENAME);
end
end
end

