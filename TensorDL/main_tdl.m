addpath('.\utils\');
addpath('.\dependency\tensor_toolbox\');

close all;
row =  256; % image height
col =  256; % image width
nb = 128;  % bands num
np = row * col;  % pixels num
brate = 0.1;     % sample rate(compression rate) for spectral domain
mb = round(brate * nb);             % sample num in spectral domain
data = load('..\data\PaviaU_256_1.mat'); % read the orginal hyperspectral data
X = (data.data); % data of size : nb * np
[mx,nx] = size(X);
if mx < 128
    X(mx +1 : 128,:) = repmat(X(mx,:),128 - mx,1);
else
    X = X(1 : 128,:);
end

%A = randn(mb,nb);% spectral CS random matrix
%A = A./repmat(sqrt(sum(A.^2,1)),[mb,1]);
A = eye(nb,nb);
Q = A * X;

sigma = 0.1;
F = X+sigma*randn(size(X));
PSNRIn = GetPSNR(F,X);

[rX] = Denoising_TensorDL(F,row,col);

error1 = norm(rX - X,'fro') / norm(X,'fro') %reconstruction error