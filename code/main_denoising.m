%==========================================================================
% This script compares hyperspectral image denosing methods
% listed as follows:
%   1. NLM3D
%   2. BM4D
%   3. LRTA
%   4. PARAFAC
%   5. TensorDL
%   6. Ying
%   7. CMESSC
%   8. Ours
%
% Three quality assessment (QA) indices -- PSNR, SSIM, and SAM
% -- are calculated for each methods after denoising.
%
% by Lei Zhang
%==========================================================================
close all;
clear;
clc;

addpath(genpath('./'));

%% Set enable bits
EN_NLM3D =0;
EN_BM4D =0;
EN_LRTA =0;
EN_PARAFAC = 0;
EN_TENSORDL =0;
EN_YING =0;
EN_CMESSC = 1;
EN_OURS = 0;
EN_WRITE = 1;% save results as file
EN_SHOW = 0;
%number_of_method=0;
%% Load HSI
%row =  16; % image height
%col =  16; % image width
%np = row * col;  % pixels num
%dataName = 'urban16';
%data = load(['./data/',dataName,'.mat']); % read the orginal hyperspectral data
%X = (data.data); % data of size [row, col, band]
%X = CovertTo2D(X); % uncomment this script when input is 3D HSI
%% parameter to choose dataset and noise 
noise='GSforBand';%GS均一
database='RS';
number_of_image=2;
number_of_noiseband=1;%混合1，均一6
%record_of_SPCL_CMESSC=zeros(3,3,2);
%% loading the record matrix
GenerateRecordMatrix %generate zero matrix
if strcmp(database,'realdata')==0
loading %input previous results to zero marix
end
%% iteration
for ii=1:number_of_noiseband

    if strcmp(noise,'GS')
    mSigma =ii*0.05;
    end
    if strcmp(database,'realdata')
    mSigma =0.11;
    end    
for i = 1: number_of_image
%% Loading
InputImageData
[mx,nx] = size(X);
%band = 90;
if EN_SHOW
    img = reshape(X(band,:),col,row);
    figure,imshow(img,[]),title('Clean Image');
end
%% Set noise level
%% noise parameter
Level = 10;% noise level
kappa = 0;% smaller kappa <--> heavier Poisson noise
%sigma_ratio = 0.3; % higher sigma_ratio <--> heavier Gaussian noise
%% Add noise
AddNoise
PSNRIn = GetPSNR(F,X);

if EN_SHOW
    img = reshape(X(band,:),col,row);
    figure,imshow(img,[]),title(['Noise Image with PSNR = ',num2str(PSNRIn)]);
end

fprintf('===== PSNR of noisy observation: %.4f ========\n',PSNRIn);

%% NLM3D
if EN_NLM3D
    tic
    methodName = 'NLM3D';
    fprintf(['1. Denoising by ',methodName,' ...\n']);
    rX = Denoising_NLM3D(F,row,col);
    t1 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);% this function can be modified by your self for save the psnr锟斤拷ssim锟斤拷 sam index into an 'error.txt' and the denoised result into a 'rX.mat'
    record_NLM3D(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t1);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['NLM3D with PSNR = ',num2str(psnr)]);
    end
end

%% BM4D
if EN_BM4D
    tic
    methodName = 'BM4D';
    fprintf(['2. Denoising by ',methodName,' ...\n']);
    rX = Denoising_BM4D(F,row,col,mSigma);
    t2 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    record_BM4D(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t2);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['BM4D with PSNR = ',num2str(psnr)]);
    end
end

%% LRTA
if EN_LRTA
    tic
    methodName = 'LRTA';
    fprintf(['3. Denoising by ',methodName,' ...\n']);
    rX = Denoising_LRTA(F,row,col);
    t3 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    %record_LRTA(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t3);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['LRTA with PSNR = ',num2str(psnr)]);
    end
end

%% PARAFAC
if EN_PARAFAC
    tic
    methodName = 'PARAFAC';
    fprintf(['4. Denoising by ',methodName,' ...\n']);
    rX = Denoising_PARAFAC(F,row,col);
    t4 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    record_PARAFAC(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t4);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['PARAFAC with PSNR = ',num2str(psnr)]);
    end
end

%% TensorDL
if EN_TENSORDL
    tic
    methodName = 'TensorDL';
    fprintf(['5. Denoising by ',methodName,' ...\n']);
    rX = Denoising_TensorDL(F,row,col,mSigma);
    t5 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    record_TENSORDL(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t5);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['TensorDL with PSNR = ',num2str(psnr)]);
    end
end


if EN_YING
    tic
    methodName = 'Ying';
    fprintf(['6. Denoising by ',methodName,' ...\n']);
    rX = Denoising_Ying(F,row,col,mSigma,X);
    t6 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    record_YING(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t6);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['Ying with PSNR = ',num2str(psnr)]);
    end
end

if EN_CMESSC
    tic
    methodName = 'CMESSC';
    fprintf(['7. Denoising by ',methodName,' ...\n']);
    %CUM=[1,5,10,20,30,50,100];
    %parH=[0.001,0.005,0.01,0.02,0.03,0.05,0.1];
    %SPCL=[1,0,1;0,1,1];
    %record_of_CUM_CMESSC=zeros(7,3,2);
    
    %for  ph=1:7
    %for c=1:7
    %for sc=1:3
    %rX = Denoising_CMESSC(F,row,col,SPCL(1,sc),SPCL(2,sc));
    rX = Denoising_CMESSC(F,row,col,true,true);
    t7 = toc;
    %[psnr, ssim, sam] = SaveResult_CMESSC(X,rX,methodName,EN_WRITE,row,col,i,SPCL(1,sc),SPCL(2,sc));
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    %fprintf([methodName, ':SP=%.4f,CL=%.4f, PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],SPCL(1,sc),SPCL(2,sc),psnr,ssim,sam,t7);
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t7);
    %record_of_SPCL_CMESSC(sc,:,i)=[psnr, ssim, sam];
    %end
    %save([noise,'_',database,'_','CMESSC_','SPCL','.mat'],'record_of_SPCL_CMESSC');
    record_CMESSC(i,:,ii)=[psnr, ssim, sam];
    %fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t7);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['CMESSC with PSNR = ',num2str(psnr)]);
    end
end

if EN_OURS
    tic
    methodName = 'Ours';
    fprintf(['8. Denoising by ',methodName,' ...\n']);
    if strcmp(noise,'GS')%decide parameter
    CLUSTER=36;
    STEP=2;
    else
    CLUSTER=93;
    STEP=3;
    end
    rX = Denoising_Ours(F,row,col,STEP,CLUSTER); % implement this function by yourself
    t8 = toc;
    [psnr, ssim, sam] = SaveResult(X,rX,methodName,mSigma,EN_WRITE,row,col,i,database,noise);
    record_OURS(i,:,ii)=[psnr, ssim, sam];
    fprintf([methodName, ': PSNR = %.4f, SSIM = %.4f, SAM = %.4f , times = %.4f\n'],psnr,ssim,sam,t8);
    if EN_SHOW
        img = reshape(X(band,:),col,row);
        figure,imshow(img,[]),title(['RLPHCS_Cov Image with PSNR = ',num2str(psnr)]);
    end
end
end
%% updating record matrix
if strcmp(database,'realdata')==0
for class=1:3
record_MEAN(:,class,ii)=[mean(record_NLM3D(:,class,ii));
mean(record_BM4D(:,class,ii));
mean(record_LRTA(:,class,ii));
mean(record_PARAFAC(:,class,ii));
mean(record_TENSORDL(:,class,ii));
mean(record_YING(:,class,ii));
mean(record_CMESSC(:,class,ii));
mean(record_OURS(:,class,ii))];
end
end
%% saving the result
%%
if EN_WRITE
saving
end
end