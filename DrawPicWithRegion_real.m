addpath(genpath('./'));
close all;
clear;
clc;
%% choose parameters
NOISE='GSforBand';% or GS
DATABASE='realdata';%or realdata
number_of_image=2;
number_of_noiseband=1;% or 6
%%  configuration
data_name_1={'PaviaU';'Wdc'};
data_name_2={'Indiana';'Urban'};
if strcmp(DATABASE,'RS')&&strcmp(NOISE,'GS')
COL=[200,200];ROW=[200,200];PSNR=0.05*[1,2,3,4,5,6];
else 
if strcmp(DATABASE,'RS')&&strcmp(NOISE,'GSforBand')
COL=[200,200];ROW=[200,200];PSNR=0.18;   
else
if strcmp(DATABASE,'realdata')
COL=[145,200];ROW=[145,200];
PSNR=0.11;
end
end
end
METHODNUMBER=7;
%METHODNAME={'ORI';'NOISE';'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
METHODNAME_R={'ORI';'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
%% Drawing
for NI=1:number_of_image
%NI=2;
for NB=1:number_of_noiseband
%DATA{1}=load(['./Ours/noiseimage/',DATABASE,'_',num2str(NI),'_SHOW_P','.mat']);%DATA{1}=load(['./Ours/groundtruth/',DATABASE,'_',num2str(NI),'.mat']);
%DATA{1}=DATA{1}.DO;
DATA{1}=load(['./NoiseImage/',DATABASE,'_',num2str(NI),'.mat']);
DATA{1}=DATA{1}.DO;
%DATA{2}=load(['./NoiseImage/',DATABASE,'_',NOISE,'_',num2str(NI),'_',num2str(PSNR(NB)),'.mat']);
%DATA{2}=DATA{2}.DO;
for M=1:7
%DATA{M+1}=load(['./',METHODNAME{M},'/pcolor/',METHODNAME{M},'_',DATABASE,num2str(NI),'_',num2str(PSNR),'_SHOW_P','.mat']);
DATA{M+1}=load(['./',METHODNAME_R{M+1},'/pcolor/',METHODNAME_R{M+1},'_',DATABASE,'_',num2str(NI),'_',num2str(PSNR(NB)),'.mat']);
DATA{M+1}=DATA{M+1}.IM;
end

for BAND=1:3
%METHODNAME_MM={'Noisy band ' ;'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
new_folder = ['.\FIGCOMP\',DATABASE,'_',num2str(NI),'_',num2str(PSNR(NB)),'_BAND',num2str(BAND)]; 
mkdir(new_folder);  % mkdir()函数创建文件夹figure(1);
for M=1:8
%HP=subplot(1,4,M);
%reset(H);
%figure(1);
PIC_INIT=DATA{M}(:,:,BAND);
%imshow(PIC_INIT);
[R,C]=size(PIC_INIT);
if NI==1
POSITION1=[80,10,20,20];
POSITION2=[110,80,20,20];
else
POSITION1=[60,150,20,20];
POSITION2=[120,155,20,20];
end
POSITION3=[1,R,C/2,C/2];
POSITION4=[C/2,R,C/2,C/2];
rectangle('Position',POSITION1,'EdgeColor','r');
rectangle('Position',POSITION2,'EdgeColor','G');
rectangle('Position',POSITION3,'EdgeColor','r');
rectangle('Position',POSITION4,'EdgeColor','G');
%FILENAME=[new_folder,'\',METHODNAME_R{M},'_',DATABASE,'_',num2str(NI),'_','_BAND',num2str(BAND),'.pdf'];
%export_fig (FILENAME);
CHOSEN1 =DATA{M}(POSITION1(2):(POSITION1(2)+POSITION1(4)),POSITION1(1):(POSITION1(1)+POSITION1(3)),BAND);
%imshow(CHOSEN1);
CHOSEN2 =DATA{M}(POSITION2(2):(POSITION2(2)+POSITION2(4)),POSITION2(1):(POSITION2(1)+POSITION2(3)),BAND);
REGION1= imresize(CHOSEN1,[floor(R/2) floor(C/2)]);
%imshow(REGION1,[]); 
%FILENAME1=[new_folder,'\',METHODNAME_R{M},'_',DATABASE,'_',num2str(NI),'_','_BAND',num2str(BAND),'_SUB1','.pdf'];
%export_fig (FILENAME1);
%[R,C]=size(REGION1);
%REGION1=rectangle('Position',[1,1,R-1,C-1],'EdgeColor','r','LineWidth',1.5);
REGION2= imresize(CHOSEN2,[floor(R/2) floor(C/2)]);
%imshow(REGION2,[]); 
%FILENAME2=[new_folder,'\',METHODNAME_R{M},'_',DATABASE,'_',num2str(NI),'_','_BAND',num2str(BAND),'_SUB2','.pdf'];
%export_fig (FILENAME2);
imshow(PIC_INIT,[])
if rem(R,2)==0
PIC_COMPLETED=[PIC_INIT;REGION1,REGION2];
else
PIC_COMPLETED=[PIC_INIT;REGION1,zeros(floor(R/2),1),REGION2];
end
figure(1);
K=imadjust(PIC_COMPLETED,[max(0,min(min(PIC_INIT(:)))),min(1,max(max(PIC_INIT(:))))],[0,1]);
I=imshow(K);
%I=imshow(PIC_COMPLETED,[]);
rectangle('Position',POSITION1,'EdgeColor','r');
rectangle('Position',POSITION2,'EdgeColor','G');
rectangle('Position',POSITION3,'EdgeColor','r','LineWidth',3);
rectangle('Position',POSITION4,'EdgeColor','G','LineWidth',3);
FILENAME=[new_folder,'\',METHODNAME_R{M},'_',DATABASE,'_',num2str(NI),'_','_BAND',num2str(BAND),'.pdf'];
export_fig(FILENAME)
end
end
end
end
