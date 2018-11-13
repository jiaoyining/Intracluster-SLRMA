function [rX] = intraClusterFiltering(X,row,col,par)

win = par.win;
mar = (win - 1) / 2;
[nb,np] = size(X);
Xp = zeros(row + 2 * mar, col + 2 * mar, nb);% padded 3D HSI
Xn = zeros(nb * win * win, np); % new HSI contain spatial infor in each spectrum

% padding 3D HSI
for i = 1 : nb
  img = (reshape(X(i,:),row,col))';
  Xp(:,:,i) = padarray(img,[mar,mar],'symmetric','both');
end
for i = 1 : row
    for j = 1 : col
        ten = Xp(i : i + 2 * mar, j : j + 2 * mar,:);
        Xn(:,(i - 1) * col + j) = ten(:);
    end
end

% dimension reduction by PCA
options.ReducedDim = 20;
[eigvector, eigvalue] = PCA(Xn, options);
Xn = eigvector' * Xn;


% clustering
K = par.cnum;
Flag = kmeansPlus(Xn,K);
rX = zeros(nb,np);
for k = 1 : K
    [Xk,index,nk] = SubClassExtract(X,Flag,k);
    [Xkn,index,nk] = SubClassExtract(Xn,Flag,k);
    Corr = GetCorrMatrix(Xkn,par.h);
    Corr = Corr ./ repmat(sum(Corr,1),nk,1);
    rX(:,index) = Xk * Corr;
end

end

function [Corr] = GetCorrMatrix(Xk, h)
[nb,nk] = size(Xk);
Corr = zeros(nk,nk);
for i = 1 : nk
    for j = i + 1 : nk
        d = Xk(:,i) - Xk(:,j);
        Corr(i,j) = exp(-1.0 * d' * d / h);
        Corr(j,i) = Corr(i,j);
    end
end
end