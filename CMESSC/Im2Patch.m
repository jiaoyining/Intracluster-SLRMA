function  X  =  Im2Patch( oX, par )
[nb, np] = size(oX); 
img = CovertTo3D( oX, par.row, par.col);
f       =   par.win;
N       =   par.row - f + 1;
M       =   par.col - f + 1;
L       =   N * M;
X       =   zeros(f * f, L);
k       =   0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  img(i:end-f+i,j:end-f+j);
        X(k,:) =  blk(:)';
    end
end