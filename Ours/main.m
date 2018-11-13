%clc;
close all;
%% HSI information
%% iteration parameter
k=17;%clusters
N=1;%
T=1;
beta=0.01;
%% noise parameter
Level = 10;% noise level
kappa = 0;% smaller kappa <--> heavier Poisson noise
sigma_ratio = 0.2; % higher sigma_ratio <--> heavier Gaussian noise
brate=0.3; 
%% opt parameter
opts.maxIterNum = 30;
opts.prior = true;
opts.tol = 1e-6;
opts.print = false;
%% evaluation
psnr_in=zeros(32,1);
psnr_out=zeros(32,1);
%% 1. Load HSI data
%%
%dataName = 'Urban64';
for index=1:32
%index=3;
X0=InputData(index);
[mx,nx] = size(X0);
%% 2.Get F=X+N;
%%
F = AddNoise_GS(X0,brate);% additive Gaussian white noise into measurements                                
fprintf('#%d compress HSI with sampling rate = %.2f and noise corruption of SNR = %d db. #\n',index,brate,Level);
%% 3.denoising
%%
[rX]=ICRPA(F,k,N,T,beta,opts);
%% 4.evaluation
%%
psnr_in(index) = GetPSNR(X0,F);
psnr_out(index) = GetPSNR(X0,rX);
end
PSNR(:,1)=psnr_in;PSNR(:,2)=psnr_out;
PSNR_MEAN=[mean(PSNR(:,1)),mean(PSNR(:,2))];