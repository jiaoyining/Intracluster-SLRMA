function [rX] = Denoising_BM4D(F,row,col,sigma)
% =========================================================================
%           Denoising Hyperspectral Image Using DM4D Algorithm
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
% [1]  Maggioni M, Katkovnik V, Egiazarian K, et al. Nonlocal transform-domain filter for 
%      volumetric data denoising and reconstruction[J]. Image Processing, IEEE Transactions on,
%      2013, 22(1): 119-133.
% =========================================================================

% modifiable parameters
if nargin < 4
    sigma             = 0.11;      % noise standard deviation (%)
end
                             % maximum intensity of the signal, must be in [0,100]
distribution      = 'Gauss'; % noise distribution
                             %  'Gauss' --> Gaussian distribution
                             %  'Rice ' --> Rician Distribution
profile           = 'mp';    % BM4D parameter profile
                             %  'lc' --> low complexity
                             %  'np' --> normal profile
                             %  'mp' --> modified profile
                             % The modified profile is default in BM4D. For 
                             % details refer to the 2013 TIP paper.
do_wiener         = 1;       % Wiener filtering
                             %  1 --> enable Wiener filtering
                             %  0 --> disable Wiener filtering
verbose           = 1;       % verbose mode

estimate_sigma    = 0;       % enable sigma estimation

F3D = CovertTo3D(F,row,col);
% perform filtering
[rX3D, sigma_est] = bm4d(F3D, distribution, (~estimate_sigma)*sigma, profile, do_wiener, verbose);

rX = CovertTo2D(rX3D);

end