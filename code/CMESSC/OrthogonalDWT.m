function [D] = OrthogonalDWT(nb)
% =========================================================================
% DESCRIPTION:
% Get a orthogonal DWT dictionary for sparsifying the spectra of HSI. Only
% when nb is the multiple of 4 (e.g. nb = 128), a dictionary of [nb,nb] can
% be generated, and thus HSI X can be sparsely represented  as X = D * Y, 
% where Y is the sparse represnetation.
% -------------------------------------------------------------------------
% INPUT ARGUMENTS:
% nb                    dimension of spectrum
% -------------------------------------------------------------------------
% OUTPUT ARGUMENTS:
% D                     orthogonal DWT dictionary of size [nb,np]
% -------------------------------------------------------------------------
% 
WaveletName = 'db1';
X = eye(nb,nb);
[xm,xn] = size(X);
DecLevel = max(floor(log2(xm)) - 1,1);
[C0, S0] = wavedec(X(:,1), DecLevel, WaveletName);
[mc,nc] = size(C0);
D = zeros(mc,xn);
D(:,1) = C0;
L = S0;
for i = 2 : xn
    C0 = wavedec(X(:,i), DecLevel, WaveletName);
    D(:,i) = C0;
end
D = D';
end