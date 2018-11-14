function [rX] = Denoising_TensorDL(F,row,col,sigma)
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
% [1] Peng Y, Meng D, Xu Z, et al. Decomposable nonlocal tensor dictionary learning
%     for multispectral image denoising[C]//Computer Vision and Pattern Recognition (CVPR),
%     2014 IEEE Conference on. IEEE, 2014: 2949-2956.
% =========================================================================

F3D = CovertTo3D(F,row,col);
if nargin < 4 || sigma == 0
    params = [];
else
    params.peak_value = 1;
    params.nsigma = sigma;
end
rX3D = TensorDL( F3D, params );
[r,c,n] = size(rX3D);
if r ~= row || c ~= col
    rX3Dn = zeros(row,col,n);
    for i = 1 : n
        img = rX3D(:,:,i);
        rX3Dn(:,:,i) = imresize(img,[row,col]);
    end
else
    rX3Dn = rX3D;
end
rX = CovertTo2D(rX3Dn);

end