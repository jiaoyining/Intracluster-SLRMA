function [rX] = Denoising_NLM3D(F,row,col)
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
% [1] Manj¨®n J V, Coup¨¦ P, Mart¨ª©\Bonmat¨ª L, et al. Adaptive non©\local means denoising of MR
%     images with spatially varying noise levels[J]. Journal of Magnetic Resonance Imaging, 
%     2010, 31(1): 192-203.
% =========================================================================

F3D = CovertTo3D(F,row,col);
rX3D = NLM3D(F3D, 5, 2, 3, 0);
rX = CovertTo2D(rX3D);
end