function [rX] = Denoising_PARAFAC(F,row,col)
% =========================================================================
%           Denoising Hyperspectral Image Using TensorDL Algorithm
% =========================================================================
% INPUT ARGUMENTS:
% F                          noisy observation matrix of size nb * np, np = row * col, nb denotes the number of bands. 
% row                        row number of each band
% col                        column number of each band.
% sigma                      noise std. variance
% =========================================================================
% OUTPUT ARGUMENTS:
% rX                        estimated clean image of size nb * np.
% =========================================================================
% [1] Liu X, Bourennane S, Fossati C. Denoising of hyperspectral images using the PARAFAC model 
%     and statistical performance analysis[J]. Geoscience and Remote Sensing, IEEE Transactions
%     on, 2012, 50(10): 3717-3724.
% =========================================================================

F3D = CovertTo3D(F,row,col);
[rX3D, k] = PARAFAC(tensor(F3D));
rX3D = double(rX3D);
rX = CovertTo2D(rX3D);
end