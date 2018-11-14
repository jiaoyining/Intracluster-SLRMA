%% main function
% description: the main function of the 3D compressive sensing for
% hyperspectral image
% author: Lei Zhang
% create time: 2014-10-15
%%
function [] = DCT_SR(dataName,nodeNum)

f_write = true;

row = 200; % image height
col = 200; % image width
nb = 128;  % bands num
np = row * col;

data = load(['../data/',dataName,'.mat']); % read the orginal hyperspectral data
X = (data.data); % data of size : nb * np
complete = 0;

for ll = 2 : 2
%     if ll == 2
%         continue;
%     end
    for mm = nodeNum : nodeNum
        
        [mx,nx] = size(X);
        if mx < 128
            X(mx +1 : 128,:) = repmat(X(mx,:),128 - mx,1);
        else
            X = X(1 : 128,:);
        end
        brate = (mm + 1) * 0.03;     % sample rate(compression rate) for spectral domain
        mb = round(brate * nb);             % sample num in spectral domain
        
        fprintf('======== HCS reconstution by OMP with  rate = %.4f, and SNR = %d  ========\n', brate, ll * 10);
        
        MCMCNum = 10;% num of Monte-Carlo runs
        Runts = 0; % average time of Monte-Carlo runs
        PSNRs = 0;
        SSIMs = 0;
        SAMs = 0;
        frX = zeros(nb,np);
        for mc = 1 : MCMCNum
            sourcePath = ['../data2/',dataName,'/',num2str(mm),'/'];
            Level = ll * 10;% noise level
            A = load([sourcePath,'A_n',num2str(Level),'_m',num2str(mc),'.mat']);
            A = A.A;
            F = load([sourcePath,'F_n',num2str(Level),'_m',num2str(mc),'.mat']);
            F = F.F;
            X0 = X;
            D = creatOvercompleteDCT(nb,nb * 4,1);
            fprintf(' Mc : %d ... \n',mc);
            tic
            rX = HCS_RLPHCS(A, D, F);%
            runt = toc;
            if mx < 128
                rX(mx + 1 : 128,:) = [];
                X0(mx + 1 : 128,:) = [];
            end
            pnsr = GetPSNR(rX,X0);
            ssim = GetSSIMofHSI(rX,X0,row,col);
            sam = GetSAMofHSI(X0,rX,row,col);
            PSNRs = PSNRs + pnsr;
            SSIMs = SSIMs + ssim;
            SAMs = SAMs + sam;
            frX = frX + rX;
            Runts = Runts + runt;
        end
        rX = frX * 1.0 / MCMCNum;
        PSNRs = PSNRs * 1.0 / MCMCNum;
        SSIMs = SSIMs * 1.0 / MCMCNum;
        SAMs = SAMs * 1.0 / MCMCNum;
        Runts = Runts * 1.0 / MCMCNum;
        
        if f_write
            savePath = ['./result/',dataName,'/',num2str(mm),'/'];
            % save the error
            if complete
                fid = fopen([savePath,'error_',num2str(Level),'.txt'],'w+');
            else
                fid = fopen([savePath,'error_',num2str(Level),'_o.txt'],'w+');
            end
            fprintf(fid,'%.12f\t%.12f\t%.12f\t%.12f',PSNRs,SSIMs,SAMs, Runts);
            fclose(fid);
            % save the 'U'
            if complete
                save([savePath,'rX_',num2str(Level),'.mat'],'rX');
            else
                save([savePath,'rX_',num2str(Level),'_o.mat'],'rX');
            end
        end
        
    end
    
end
end

