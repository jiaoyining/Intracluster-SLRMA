function [rX] = Denoising_LRTA(F,row,col)
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
% [1] Renard N, Bourennane S, Blanc-Talon J. Denoising and dimensionality reduction using
%     multilinear tools for hyperspectral images[J]. Geoscience and Remote Sensing Letters, 
%     IEEE, 2008, 5(2): 138-142.
% =========================================================================

F3D = CovertTo3D(F,row,col);
rX3D = LRTA(tensor(F3D));
rX3D = double(rX3D);
rX = CovertTo2D(rX3D);
end