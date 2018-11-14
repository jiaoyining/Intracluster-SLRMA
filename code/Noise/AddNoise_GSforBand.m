
function [F,mSigma] = AddNoise_GSforBand(X0)
%for each band, add Gaussian noise of diffenent intensity
[row,col]=size(X0);
randn('seed',0);
rand('seed',0);
std=rand(row,1)*0.25+0.05;
mSigma=mean(std);
F=X0;
for cnt=1:row
F(cnt,:)=X0(cnt,:)+randn(1,col)*std(cnt);
end

