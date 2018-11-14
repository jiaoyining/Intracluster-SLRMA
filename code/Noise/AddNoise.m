%% according to previous input,add noise to database
%%
if strcmp(database,'realdata')
F=X;
else
if strcmp(noise,'GS')
F=AddNoise_GS(X,mSigma);
else
if strcmp(noise,'GSforBand')
[F,mSigma]=AddNoise_GSforBand(X);
else
if strcmp(noise,'GSforBand2')
F= AddNoiseForBand2(X);
end
end
end
end
    
    
    
   

