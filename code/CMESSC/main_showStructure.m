% =========================================================================
% Reweighted Laplace prior based hyperspectral compressive sensing - based 
% HSI reconstruction, Version 1.0
% Copyright(c) 2015 Lei Zhang, Wei Wei, Yanning Zhang, Chunna Tian, Fei Li.
% All Rights Reserved.
%
% -------------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%--------------------------------------------------------------------------
%
% This is an implementation of the algorithm for non-blind image deblurring
% 
% Please refer to the following paper if you use this code:
%
% Lei Zhang, Wei Wei, Yanning Zhang, Chunna Tian, and Fei Li. 
% "Reweighted Laplace Prior Based Hyperspectral Compressive Sensing for 
%  Unknown Sparsity", in IEEE Conf. on Computer Vision and Pattern 
%  Recoginition (CVPR), 2015.
%
%--------------------------------------------------------------------------

clc;
close all;

%% HSI information
%%
row = 200;                                         % height of band image 
col = 200;                                         % width of band image
nb = 128;                                          % bands num
np = row * col;                                    % pixel num


%% 1. Load HSI data
%%
dataName = 'Urban';
data = load(['../data/',dataName,'.mat']);         % read the orginal hyperspectral data
X = (data.data);                                   % HSI of size : nb * np, normalized to [0,1]
[mx,nx] = size(X);
if mx < 128
    X(mx +1 : 128,:) = repmat(X(mx,:),128 - mx,1); % padding data
else
    X = X(1 : 128,:);                              % only consider the 128 continuous bands in data
end
X0 = X;                                            % original HSI of size [nb,np]



%% 2. Compress HSI along spectral dimension
%%
brate = 0.5;                                       % sampling rate : mb / nb
mb = round(brate * nb);                            % measurements number
A = randn(mb,nb);                                  % random sampling matrix
A = A./repmat(sqrt(sum(A.^2,1)),[mb,1]);           % normalized column
Q = A * X;                                         % compress the spectral domain
Level = 20;                                        % noise level
F = awgn(Q,Level);                                 % additive Gaussian white noise into measurements
fprintf('# compress HSI with sampling rate = %.2f and noise corruption of SNR = %d db. #\n',brate,Level);


%% 3. Reconstruct HSI from noise measurements
%%
complete = 1;                                      % dictionary type: 1 denotes orthogornal DWT dictionary, 0 denotes the over-complete DCT dictionary
if complete                                        % generate spectrum dictionary
    D = OrthogonalDWT(nb);
else
    D = creatOvercompleteDCT(nb,nb * 2,1);
end
fprintf('reconstruc HSI with RLPHCS ...\n');

oY = D' * X;
oCov = cov(oY');

[nb,np] = size(F);
sqnp = sqrt(np);
opts.maxIterNum = 250;
opts.prior = true;
opts.tol = 1e-9;
opts.print = false;

%% sparse learning
[rY, BregD, rCov] = RLPHCS_Rec_structure(A, D, F, opts, oCov);
[rY_Cov, BregD_Cov, rCov_Cov] = RLPHCS_Cov_Rec_structure(A, D, F, opts, oCov);

%% HSI reconstruction
rX = max(D * rY .* sqnp,0);
rX = min(rX,1);

rX_Cov = max(D * rY_Cov .* sqnp,0);
rX_Cov = min(rX_Cov,1);

% reconstruct HSI from measurements with RLPHCS algorithm
if mx < 128                                       % remove the padded bands
    rX(mx + 1 : 128,:) = [];   
    rX_Cov(mx + 1 : 128,:) = []; 
    X0(mx + 1 : 128,:) = [];
end


%% 4. Evaluation
%%
psnr_ = GetPSNR(rX,X0);
ssim_ = GetSSIMofHSI(rX,X0,row,col);
sam_ = GetSAMofHSI(X0,rX,row,col);

fprintf('RLPHCS: psnr = %.4f, ssim = %.4f, sam = %.4f.\n',psnr_,ssim_,sam_);

psnr_ = GetPSNR(rX_Cov,X0);
ssim_ = GetSSIMofHSI(rX_Cov,X0,row,col);
sam_ = GetSAMofHSI(X0,rX_Cov,row,col);

fprintf('RLPHCS_Cov: psnr = %.4f, ssim = %.4f, sam = %.4f.\n',psnr_,ssim_,sam_);
