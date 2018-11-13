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
DADA_O=load(['./data/',DATABASE,'/',data_name_1{NI},'.mat']);%input groundtruth
DATA_S{NI}{1}=CovertTo2D(DADA_O.data);    
    
for M=1:METHODNUMBER
clear DO RecordOfImage IM;
PSNR=0.18;
RecordOfImage= load(['.\',METHODNAME{M},'\result\',DATABASE,'_',NOISE,num2str(NI),'_',num2str(PSNR),'.mat']);
RecordOfImage=RecordOfImage.rX;
%RecordOfImage=CovertTo3D(RecordOfImage,200,200);
DATA_S{NI}{M+1}=RecordOfImage;
end
end

for NI=1:2
BAND=[103,191];

for M=1:7
for B=1:BAND(NI)
GT=DATA_S{NI}{1}(B,:);
IM=DATA_S{NI}{M+1}(B,:);
PSNRSAVER{NI}(B,M) = GetPSNR(GT,IM);
SSIMSAVER{NI}(B,M)= GetSSIMofHSI(GT,IM,200,200);
end
for S=1:200
GT_S=DATA_S{NI}{1}(:,S);
IM_S=DATA_S{NI}{M+1}(:,S);
SAMSAVER(S,M,NI)= GetSAMofHSI(GT_S,IM_S,1,1);
end
end
end

for Image=1:2

    figure((Image-1)*3+1);
plot(1:BAND(Image),PSNRSAVER{Image}(:,1),'g-.','LineWidth',1);
hold on;
plot(1:BAND(Image),PSNRSAVER{Image}(:,2),'b-.','LineWidth',1);
hold on;
plot(1:BAND(Image),PSNRSAVER{Image}(:,3),'y-.','LineWidth',1);
hold on;
plot(1:BAND(Image),PSNRSAVER{Image}(:,4),'m-.','LineWidth',1);
hold on;
plot(1:BAND(Image),PSNRSAVER{Image}(:,5),'c-.','LineWidth',1);
hold on;
plot(1:BAND(Image),PSNRSAVER{Image}(:,6),'k-.','LineWidth',1);
hold on;
plot(1:BAND(Image),PSNRSAVER{Image}(:,7),'r','LineWidth',1.5);
xlabel('Band number','FontSize',15);
set(gca,'XTick', 1: 30 : SPECN(NI));
set(gca,'XTickLabel',{'1', '30', '60', '90','120','150','180','210'});
ylabel('PSNR','FontSize',15);
%axis([1,BAND(Image),~,~]);
grid on;
set(gcf,'unit','centimeters','position',[10 5 12 10]);
h1=legend('NLM3D','BM4D','LRTA','PARAFAC','TensorDL','CMESSC','Ours','Location','eastoutside');
set(h1,'Box','off');



    figure((Image-1)*3+2);
plot(1:BAND(Image),SSIMSAVER{Image}(:,1),'g-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SSIMSAVER{Image}(:,2),'b-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SSIMSAVER{Image}(:,3),'y-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SSIMSAVER{Image}(:,4),'m-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SSIMSAVER{Image}(:,5),'c-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SSIMSAVER{Image}(:,6),'k-.','LineWidth',1);
hold on;
plot(1:BAND(Image),SSIMSAVER{Image}(:,7),'r','LineWidth',1.5);
hold on;
xlabel('Band number','FontSize',15);

set(gca,'XTick', 1: 30 : SPECN(NI));
set(gca,'XTickLabel',{'1', '30', '60', '90','120','150','180','210'});
ylabel('SSIM','FontSize',15);
axis auto;
grid on;
set(gcf,'unit','centimeters','position',[10 5 12 10]);
%h2=legend('NLM3D','BM4D','LRTA','PARAFAC','TensorDL','CMESSC','Ours','Location','eastoutside');
%set(h2,'Box','off');

    figure((Image-1)*3+3);
plot(1:200,SAMSAVER(:,1,Image),'g-.','LineWidth',1);
hold on;
plot(1:200,SAMSAVER(:,2,Image),'b-.','LineWidth',1);
hold on;
plot(1:200,SAMSAVER(:,3,Image),'y-.','LineWidth',1);
hold on;
plot(1:200,SAMSAVER(:,4,Image),'m-.','LineWidth',1);
hold on;
plot(1:200,SAMSAVER(:,5,Image),'c-.','LineWidth',1);
hold on;
plot(1:200,SAMSAVER(:,6,Image),'k-.','LineWidth',1);
hold on;
plot(1:200,SAMSAVER(:,7,Image),'r','LineWidth',1.5);
hold on;
xlabel('Pixel number','FontSize',15);
ylabel('SAM','FontSize',15);
axis auto;
grid on;
set(gca,'XTick', 1: 50 : 200);
set(gca,'XTickLabel',{'1', '50', '100', '150','200'});
set(gcf,'unit','centimeters','position',[10 5 12 10]);
%h3=legend('NLM3D','BM4D','LRTA','PARAFAC','TensorDL','CMESSC','Ours','Location','eastoutside');
%set(h3,'Box','off');
end


  