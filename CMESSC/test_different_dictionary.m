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
data = load(['./data/',dataName,'.mat']);         % read the orginal hyperspectral data
X = (data.data);                                   % HSI of size : nb * np, normalized to [0,1]
[mx,nx] = size(X);
if mx < 128
    X(mx +1 : 128,:) = repmat(X(mx,:),128 - mx,1); % padding data
else
    X = X(1 : 128,:);                              % only consider the 128 continuous bands in data
end
X0 = X;                                            % original HSI of size [nb,np]

D1 = OrthogonalDWT(nb);
D2 = creatOvercompleteDCT(nb,nb * 4,1);
D3 = DictionaryLearning(X0);

%% 2. Compress HSI along spectral dimension
%%
PSNRs = zeros(3,9);
SSIMs = zeros(3,9);
SAMs = zeros(3,9);

if mx < 128                                       % remove the padded bands
    X0(mx + 1 : 128,:) = [];
end

for i = 1 : 9
    brate = 0.05 * (i + 1);                            % sampling rate : mb / nb
    mb = round(brate * nb);                            % measurements number
    A = randn(mb,nb);                                  % random sampling matrix
    A = A./repmat(sqrt(sum(A.^2,1)),[mb,1]);           % normalized column
    Q = A * X;                                         % compress the spectral domain
    Level = 10;                                        % noise level
    F = awgn(Q,Level);                                 % additive Gaussian white noise into measurements
    fprintf('# compress HSI with sampling rate = %.2f and noise corruption of SNR = %d db. #\n',brate,Level);
    
    
    %% 3. Reconstruct HSI from noise measurements
    %%
    
    fprintf('reconstruc HSI with RLPHCS 1...\n');
    rX1 = HCS_RLPHCS(A, D1, F);                         % reconstruct HSI from measurements with RLPHCS algorithm
    fprintf('reconstruc HSI with RLPHCS 2...\n');
    rX2 = HCS_RLPHCS(A, D2, F);                         % reconstruct HSI from measurements with RLPHCS algorithm
    fprintf('reconstruc HSI with RLPHCS 3...\n');
    rX3 = HCS_RLPHCS(A, D3, F);                         % reconstruct HSI from measurements with RLPHCS algorithm
    if mx < 128                                       % remove the padded bands
        rX1(mx + 1 : 128,:) = [];
        rX2(mx + 1 : 128,:) = [];
        rX3(mx + 1 : 128,:) = [];
    end
       
    %% 4. Evaluation
    %%
    psnr_ = GetPSNR(rX1,X0);
    ssim_ = GetSSIMofHSI(rX1,X0,row,col);
    sam_ = GetSAMofHSI(X0,rX1,row,col);
    fprintf('psnr1 = %.4f, ssim1 = %.4f, sam1 = %.4f.\n',psnr_,ssim_,sam_);
    PSNRs(1,i) = psnr_;
    SSIMs(1,i) = ssim_;
    SAMs(1,i) = sam_;
    
    psnr_ = GetPSNR(rX2,X0);
    ssim_ = GetSSIMofHSI(rX2,X0,row,col);
    sam_ = GetSAMofHSI(X0,rX2,row,col);
    fprintf('psnr2 = %.4f, ssim2 = %.4f, sam2 = %.4f.\n',psnr_,ssim_,sam_);
    PSNRs(2,i) = psnr_;
    SSIMs(2,i) = ssim_;
    SAMs(2,i) = sam_;
    
    psnr_ = GetPSNR(rX3,X0);
    ssim_ = GetSSIMofHSI(rX3,X0,row,col);
    sam_ = GetSAMofHSI(X0,rX3,row,col);
    fprintf('psnr3 = %.4f, ssim3 = %.4f, sam3 = %.4f.\n',psnr_,ssim_,sam_);
    PSNRs(3,i) = psnr_;
    SSIMs(3,i) = ssim_;
    SAMs(3,i) = sam_;
end