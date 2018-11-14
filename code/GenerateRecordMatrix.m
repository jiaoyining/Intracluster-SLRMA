%% these empty matrix are used to saving PSNR,SSIM,SAM
%%
record_NLM3D=zeros(number_of_image,3,number_of_noiseband);
record_BM4D=zeros(number_of_image,3,number_of_noiseband);
record_LRTA=zeros(number_of_image,3,number_of_noiseband);
record_PARAFAC=zeros(number_of_image,3,number_of_noiseband);
record_TENSORDL=zeros(number_of_image,3,number_of_noiseband);
record_CMESSC=zeros(number_of_image,3,number_of_noiseband);
record_YING=zeros(number_of_image,3,number_of_noiseband);
record_OURS=zeros(number_of_image,3,number_of_noiseband);
record_MEAN=zeros(8,3,number_of_noiseband);