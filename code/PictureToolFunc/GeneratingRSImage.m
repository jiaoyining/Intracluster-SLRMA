%% Generating Matrix to draw band comparing picture
%%
%   1. NLM3D
%   2. BM4D
%   3. LRTA
%   4. PARAFAC
%   5. TensorDL
%   7. CMESSC
%   8. Ours
addpath(genpath('./'));
close all;
clear;
clc;
data_name_1={'PaviaU';'Wdc'};
%%
NOISE='GSforBand';
DATABASE='RS';
number_of_image=2;
number_of_noiseband=1;
if number_of_noiseband==1
PSNR=0.18;
else 
PSNR=0.05*[1,2,3,4,5,6];
end
%%
METHODNUMBER=7;
COL=[200,200];ROW=[200,200];
METHODNAME={'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
BANDA=68;
BANDB=29;
BANDC=2;
BANDD=50;
BANDE=36;
BANDF=15;
BANDNUMBER=[BANDA,BANDB,BANDC;BANDD,BANDE,BANDF];
%BANDNUMBER1=[3,110,218;2,103,204];
for NI=1:number_of_image
clear DO RecordOfImage IM;
DADA_I=load(['./data/',DATABASE,'/',data_name_1{NI},'.mat']);
DATA_I=DADA_I.data;
savePath = ['./groundtruth/'];

DO(:,:,1)=DATA_I(:,:,BANDNUMBER(NI,1));
DO(:,:,2)=DATA_I(:,:,BANDNUMBER(NI,2));
DO(:,:,3)=DATA_I(:,:,BANDNUMBER(NI,3));
save([savePath,DATABASE,'_',num2str(NI),'.mat'],'DO');
%savePath = ['./noiseimage/'];
%save([savePath,DATABASE,'_',num2str(NI),'.mat'],'DO');
for M=1:METHODNUMBER

%savePath = ['./',METHODNAME{M},'/pcolor/'];
%save([savePath,METHODNAME{M},'_',DATABASE,'_',NOISE,'_',num2str(NI),'_',num2str(PSNR(NB)),'.mat'],'IM');
for NB=1:number_of_noiseband

RecordOfImage= load(['.\',METHODNAME{M},'\result\',DATABASE,'_',NOISE,num2str(NI),'_',num2str(PSNR(NB)),'.mat']);
%RecordOfImage=RecordOfImage.rX;
%RecordOfImage= load(['.\',METHODNAME{M},'\result\',DATABASE,'_',NOISE,num2str(NI),'_',num2str(PSNR(NB)),'.mat']);
RecordOfImage=RecordOfImage.rX;
%RecordOfImage=CovertTo3D(RecordOfImage,200,200);
RecordOfImage=CovertTo3D(RecordOfImage,COL(NI),ROW(NI));
IM(:,:,1)=RecordOfImage(:,:,BANDNUMBER(NI,1));
IM(:,:,2)=RecordOfImage(:,:,BANDNUMBER(NI,2));
IM(:,:,3)=RecordOfImage(:,:,BANDNUMBER(NI,3));
savePath = ['./',METHODNAME{M},'/pcolor/'];
save([savePath,METHODNAME{M},'_',DATABASE,'_',NOISE,'_',num2str(NI),'_',num2str(PSNR(NB)),'.mat'],'IM');
end
end
end