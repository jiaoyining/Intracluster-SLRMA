function [psnr, ssim, sam] = SaveResult(X,rX,methodName,sigma_ratio,f_write,row,col,i,database,noise)
    psnr = GetPSNR(X,rX);
    ssim = GetSSIMofHSI(X,rX,row,col);
    sam = GetSAMofHSI( X,rX,row,col );
    if f_write
        savePath = ['./',methodName,'/result/'];
        %savePath = ['./',methodName,'/result/'];
        fid = fopen([savePath,database,'_',noise,num2str(i),'_',num2str(sigma_ratio),'.txt'],'w+');
        fprintf(fid,'%.4f\t%.4f\t%.4f\n',psnr,ssim,sam);
        fclose(fid);
        % save the 'U'
        save([savePath,'RS_GS',num2str(i),'_',num2str(sigma_ratio),'.mat'],'rX');
    end
end