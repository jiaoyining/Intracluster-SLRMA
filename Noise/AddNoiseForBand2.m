function [ nX ] = AddNoiseForBand2( X )
[nb,np] = size(X);
rand('seed',0);
snr = 10 + rand(nb,1) * 20;
nX = X;
for i = 1 : nb
    nX(i,:) = awgn(X(i,:),snr(i));
end
end