%% main function
% description: the main function of the 3D compressive sensing for
% hyperspectral image
% author: Lei Zhang
% create time: 2014-10-15
%%
function [] = RLPHCS_SR(dataName,nodeNum)

f_write = true;

row = 200; % image height
col = 200; % image width
nb = 128;  % bands num
np = row * col;

data = load(['../data/',dataName,'.mat']); % read the orginal hyperspectral data
X = (data.data); % data of size : nb * np
complete = 1;

[mx,nx] = size(X);
if mx < 128
    X(mx +1 : 128,:) = repmat(X(mx,:),128 - mx,1);
else
    X = X(1 : 128,:);
end

for ll = 1 : 2
    for mm = nodeNum : nodeNum
        
        brate = (mm + 1) * 0.05;     % sample rate(compression rate) for spectral domain
        mb = round(brate * nb);             % sample num in spectral domain
        
        fprintf('======== HCS reconstution by OMP with  rate = %.4f, and SNR = %d  ========\n', brate, ll * 10);
        
        MCMCNum = 10;% num of Monte-Carlo runs
        Runts = 0; % average time of Monte-Carlo runs
        if mx < 128
            frX = zeros(mx,np);
        else
            frX = zeros(nb,np);
        end
        for mc = 1 : MCMCNum
            sourcePath = ['../data2--dictionary/',dataName,'/',num2str(mm),'/'];
            Level = ll * 10;% noise level
            A = load([sourcePath,'A_n',num2str(Level),'_m',num2str(mc),'.mat']);
            A = A.A;
            F = load([sourcePath,'F_n',num2str(Level),'_m',num2str(mc),'.mat']);
            F = F.F;
            X0 = X;
            if complete
                D = (OrthogonalSR(eye(nb,nb), 'dwt', 1, row, col))';
            else
                D = creatOvercompleteDCT(nb,nb * 2,1);
            end
            fprintf(' Mc : %d ... \n',mc);
            tic
            rX = HCS_RLPHCS(A, D, F);%
            runt = toc;
            frX = frX + rX;
            Runts = Runts + runt;
        end
        rX = frX * 1.0 / MCMCNum;
        if mx < 128
            rX(mx + 1 : 128,:) = [];
            X0(mx + 1 : 128,:) = [];
        end
        PSNRs = GetPSNR(rX,X0);
        SSIMs = GetSSIMofHSI(rX,X0,row,col);
        SAMs = GetSAMofHSI(X0,rX,row,col);
        Runts = Runts * 1.0 / MCMCNum;
        
        if f_write
            savePath = ['./result/noise/',dataName,'/',num2str(mm),'/'];
            % save the error
            if complete
                fid = fopen([savePath,'error_',num2str(Level),'.txt'],'w+');
            else
                fid = fopen([savePath,'error_',num2str(Level),'.txt'],'w+');
            end
            fprintf(fid,'%.12f\t%.12f\t%.12f\t%.12f',PSNRs,SSIMs,SAMs, Runts);
            fclose(fid);
            % save the 'U'
            if complete
                save([savePath,'rX_',num2str(Level),'.mat'],'rX');
            else
                save([savePath,'rX_',num2str(Level),'.mat'],'rX');
            end
        end
        
    end
    
end
end

