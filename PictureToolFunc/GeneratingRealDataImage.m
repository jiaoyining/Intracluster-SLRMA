%% Generating Matrix to draw band comparing picture
%%
%   1. NLM3D
%   2. BM4D
%   3. LRTA
%   4. PARAFAC
%   5. TensorDL
%   7. CMESSC
%   8. Ours
close all;
clear;
clc;
%data_name_1={'PaviaU';'Wdc'};
data_name_2={'Indiana';'Urban'};
DATABASE='realdata';
NOISE='GSforBand';
number_of_image=2;
number_of_noiseband=1;
METHODNUMBER=7;
COL=[145,200];ROW=[145,200];
METHODNAME={'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
BANDNUMBER1=[3,110,218;2,103,207];
PSNR=0.11;
for NI=1:number_of_image
clear DO IM
DADA_I=load(['./data/real data/',data_name_2{NI},'.mat']);
DATA_I=DADA_I.data;
DATA_O=DATA_I;
DO(:,:,1)=DATA_O(:,:,BANDNUMBER1(NI,1));
DO(:,:,2)=DATA_O(:,:,BANDNUMBER1(NI,2));
DO(:,:,3)=DATA_O(:,:,BANDNUMBER1(NI,3));
savePath = ['./NoiseImage/'];
save([savePath,DATABASE,'_',num2str(NI),'.mat'],'DO');
%DO_1=[max(max(DO(:,:,1))),min(min(DO(:,:
for M=1:METHODNUMBER
RecordOfImage= load(['.\',METHODNAME{M},'\result\realdata',num2str(NI),'_',num2str(PSNR),'.mat']);
RecordOfImage=RecordOfImage.rX;
%RecordOfImage=CovertTo3D(RecordOfImage,200,200);
RecordOfImage=CovertTo3D(RecordOfImage,COL(NI),ROW(NI));
IM(:,:,1)=RecordOfImage(:,:,BANDNUMBER1(NI,1));
IM(:,:,2)=RecordOfImage(:,:,BANDNUMBER1(NI,2));
IM(:,:,3)=RecordOfImage(:,:,BANDNUMBER1(NI,3));
savePath = ['./',METHODNAME{M},'/pcolor/'];
save([savePath,METHODNAME{M},'_',DATABASE,'_',num2str(NI),'_',num2str(PSNR),'.mat'],'IM');
end
end
