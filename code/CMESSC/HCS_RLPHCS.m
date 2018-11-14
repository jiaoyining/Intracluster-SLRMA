function [rX] = HCS_RLPHCS(A, D, F)
% =========================================================================
% DESCRIPTION:
% The algorithm recover HSI X from compressive measurement F acoording to 
% the observation model:
%                        F = AX + N = ADY + N
% where D is a given dictionary, X is sparsely represented on D as X = DY,
% Y is the sparse coefficient matrix and N is noise corruption.
% -------------------------------------------------------------------------
% INPUT ARGUMENTS:
% A                      random sampling matrix of size [mb, nb]
% D                      dictionary of size [nb,nd]
% F                      noisy measurement matrix of size [mb, np], 
%                        np = row * col, nb denotes the number of bands 
% -------------------------------------------------------------------------
% OUTPUT ARGUMENTS:
% rX                     reconstructed HSI of size [nb, np]
% -------------------------------------------------------------------------
% 

[nb,np] = size(F);
sqnp = sqrt(np);
opts.maxIterNum = 300;
opts.prior = true;
opts.tol = 1e-3;
opts.print = false;

%% sparse learning
[rY0,lam] = RLPHCS_Rec(A, D, F, opts);

%% covariance learning
[rY] = RLPHCS_Cov_Rec(A, D, F, opts, lam, rY0);

rX = D * rY .* sqnp;
%rX = max(D * rY .* sqnp,0);
%rX = min(rX,1);

end