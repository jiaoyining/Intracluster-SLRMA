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
addpath(genpath('./utf8''export_fig'))

close all;
clear;
clc;
data_name_1={'PaviaU';'Wdc'};
%%
NOISE='GSforBand';
DATABASE='RS';
number_of_image=2;
number_of_noiseband=1;
%%
BANDA=68;
BANDB=29;
BANDC=2;
BANDD=50;
BANDE=36;
BANDF=15;
BANDNUMBER=[BANDA,BANDB,BANDC;BANDD,BANDE,BANDF];
if number_of_noiseband==1
PSNR=0.18;
else 
PSNR=0.05*[1,2,3,4,5,6];
end
%BANDNUMBER1=[3,110,218;2,103,204];
for NI=1:number_of_image
clear DO RecordOfImage IM;
if strcmp(DATABASE,'RS')
[X,row,col,~]=InputData_RS(NI);COL=[200,200];ROW=[200,200];
else
if strcmp(DATABASE,'realdata')
[X,row,col,~]=InputData_RealData(NI);COL=[145,200];ROW=[200,200];
end
end
%band = 90;
%%
for NB=1:number_of_noiseband
if strcmp(database,'realdata')
F=X;
else
if strcmp(NOISE,'GS')
F=AddNoise_GS(X,PSNR(NB));
else
if strcmp(NOISE,'GSforBand')
[F,mSigma]=AddNoise_GSforBand(X);
end
end
end
DATA_I=CovertTo3D(F,COL(NI),ROW(NI));
%savePath = ['./Ours/groundtruth/'];
%save([savePath,'_',DATABASE,'_',num2str(NI),'.mat'],'DO');
DO(:,:,1)=DATA_I(:,:,BANDNUMBER(NI,1));
DO(:,:,2)=DATA_I(:,:,BANDNUMBER(NI,2));
DO(:,:,3)=DATA_I(:,:,BANDNUMBER(NI,3));
savePath = ['./NoiseImage/'];
save([savePath,DATABASE,'_',NOISE,'_',num2str(NI),'_',num2str(PSNR(NB)),'.mat'],'DO');

 for bands=1:3
     FILENAME=[savePath,'NOISE_',DATABASE,'_',num2str(NI),'_',num2str(PSNR(NB)),'_BAND',num2str(bands),'.bmp'];
     FILENAME2=[savePath,'NOISE_',DATABASE,'_',num2str(NI),'_',num2str(PSNR(NB)),'_BAND',num2str(bands),'.pdf'];
     fig=figure(1);
     imshow(DO(:,:,bands));
     %saveas(1,FILENAME2);
     export_fig (FILENAME2)
     %imshow(FILENAME2);
     
     
      
end  
    
end
end

