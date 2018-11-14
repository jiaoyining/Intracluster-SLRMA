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
SPECN=[103,191];
%COL=[145,200];ROW=[145,200];
for NI=1:number_of_image
DADA_O=load(['./data/',DATABASE,'/',data_name_1{NI},'.mat']);
DATA_S{NI}{1}=DADA_O.data;    
    
for M=1:METHODNUMBER
clear DO RecordOfImage IM;
PSNR=0.18;
RecordOfImage= load(['.\',METHODNAME{M},'\result\',DATABASE,'_',NOISE,num2str(NI),'_',num2str(PSNR),'.mat']);
RecordOfImage=RecordOfImage.rX;
RecordOfImage=CovertTo3D(RecordOfImage,200,200);
DATA_S{NI}{M+1}=RecordOfImage;
end
end
%LOCATION_ROW(1,:)=[58,15,110];LOCATION_COL(1,:)=[60,88,150];
%LOCATION_ROW(2,:)=[50,190,180];LOCATION_COL(2,:)=[50,90,130];
LOCATION_ROW(1,:)=[58,15,110];LOCATION_COL(1,:)=[60,88,150];
LOCATION_ROW(2,:)=[50,120,140];LOCATION_COL(2,:)=[50,90,30];
for NI=1:2
BAND=[103,191];

for P=1:3
for M=1:7
GT=DATA_S{NI}{1}(LOCATION_ROW(NI,P),LOCATION_COL(NI,P),:);
IM=DATA_S{NI}{M+1}(LOCATION_ROW(NI,P),LOCATION_COL(NI,P),:);
SPECTRA_SELECTION{NI}(:,M,P) = IM-GT;
%SSIM_SELECTION{NI}(B,M)= GetSSIMofHSI(GT,IM,200,200);
end

end
end

for Image=1:2

for P=1:3
    figure((Image-1)*3+P);
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,1,P),'g-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,2,P),'b-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,3,P),'y-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,4,P),'m-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,5,P),'c-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,6,P),'k-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SPECTRA_SELECTION{Image}(:,7,P),'r','LineWidth',1.5);
xlabel('Band number','FontSize',15);
ylabel('Reflectance difference','FontSize',15);
if P==1
title('blue');
else
if P==2
title('red');
else
title('yellow');
end
end
if Image==1
set(gca,'XTick',[1,30,60,90]);
set(gca,'XTickLabel',{'1', '30', '60', '90'});
else
set(gca,'XTick', [1,30,60,90,120,150,180]);
set(gca,'XTickLabel',{'1', '30', '60', '90','120','150','180'});
end
%axis([1,BAND(Image),~,~]);
grid on;
%h1=legend('NLM3D','BM4D','LRTA','PARAFAC','TensorDL','CMESSC','Ours','Location','eastoutside');
%set(h1,'Box','off');
set(gcf,'unit','centimeters','position',[10 5 12 10]);
end
end
