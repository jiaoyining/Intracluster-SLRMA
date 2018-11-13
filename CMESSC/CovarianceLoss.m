function [V] = CovarianceLoss(A,B)
[m,n] = size(A);
I = eye(m,m);
V = trace(A / (B + 1e-9 .* I) - I);
V = log(V * V);
end