function  [ dim ]  =  Patch2Img( Ys, par )
b = par.win;
h = par.row;
w = par.col;
N = h - b + 1;
M = w - b + 1;
r = [1 : N];
c = [1 : M];

dim     =  zeros(h,w);
wei     =  zeros(h,w);
k       =   0;
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        dim(r-1+i,c-1+j)  =  dim(r-1+i,c-1+j) + reshape( Ys(k,:)', [N M]);
        wei(r-1+i,c-1+j)  =  wei(r-1+i,c-1+j) + 1;
    end
end

end