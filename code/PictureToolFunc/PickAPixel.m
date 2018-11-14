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
data_name_1={'PaviaU';'Wdc'};
NOISE='GSforBand';
DATABASE='RS';
number_of_image=2;
number_of_noiseband=1;
METHODNUMBER=7;
METHODNAME={'NLM3D';'BM4D';'LRTA';'PARAFAC';'TensorDL';'CMESSC';'Ours'};
%COL=[145,200];ROW=[145,200];
LOCATION_ROW(1,:)=[58,15,110];LOCATION_COL(1,:)=[60,88,150];
LOCATION_ROW(2,:)=[50,120,140];LOCATION_COL(2,:)=[50,90,30];
for NI=1:number_of_image
DADA_O=load(['./data/',DATABASE,'/',data_name_1{NI},'.mat']);
DATA_S=DADA_O.data;
figure(NI);imshow(DATA_S(:,:,35));
hold on;
plot(LOCATION_ROW(NI,1),LOCATION_COL(NI,1),'Marker','square','MarkerIndices',1,'MarkerSize',10,'LineWidth',1.5);%À¶
hold on;
plot(LOCATION_ROW(NI,2),LOCATION_COL(NI,2),'Marker','square','MarkerIndices',1,'MarkerSize',10,'LineWidth',1.5);%ºì
hold on;
plot(LOCATION_ROW(NI,3),LOCATION_COL(NI,3),'Marker','square','MarkerIndices',1,'MarkerSize',10,'LineWidth',1.5);%»Æ
end
