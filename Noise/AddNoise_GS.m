function [F] = AddNoise_GS(X0,brate)
% uniform Gaussian noise
randn('seed',0);
F = X0 + brate* randn(size(X0));
end

