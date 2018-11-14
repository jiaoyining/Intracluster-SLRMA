%% make excel and save the PSNR,SSIM,SAM

filename1='GfB_PaviaU.xlsx';
filename2='GfB_Wdc.xlsx';
filename3='GS_PaviaU.xlsx';
filename4='GS_Wdc.xlsx';
%% parameters to change
noise='GS';
database='RS';
number_of_image=2;
number_of_noiseband=6;
%%
record_the_result 
loading
record_PaviaU=zeros(8,3,number_of_noiseband);
record_Wdc=zeros(8,3,number_of_noiseband);
for ii=1:number_of_noiseband
for class=1:3
record_PaviaU(:,class,ii)=[record_NLM3D(1,class,ii);
record_BM4D(1,class,ii);
record_LRTA(1,class,ii);
record_PARAFAC(1,class,ii);
record_TENSORDL(1,class,ii);
record_YING(1,class,ii);
record_CMESSC(1,class,ii);
record_OURS(1,class,ii)];
record_Wdc(:,class,ii)=[record_NLM3D(2,class,ii);
record_BM4D(2,class,ii);
record_LRTA(2,class,ii);
record_PARAFAC(2,class,ii);
record_TENSORDL(2,class,ii);
record_YING(2,class,ii);
record_CMESSC(2,class,ii);
record_OURS(2,class,ii)];
end
if strcmp(noise,'GS')
xlswrite(filename3,record_PaviaU(:,:,ii),ii);
xlswrite(filename4,record_Wdc(:,:,ii),ii);
else
xlswrite(filename1,record_PaviaU(:,:,ii),ii);
xlswrite(filename2,record_Wdc(:,:,ii),ii);
end
