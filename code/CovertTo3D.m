function [ Y ] = CovertTo3D( X,row,col )
%Convet the 2D matrix X of size [band, row * col] into a 3D matrix of size   [row, col, band] 

[nb,np] = size(X);
Y = zeros(row,col,nb);
for i = 1 : nb
    img = reshape(X(i,:),row,col);
    Y(:,:,i) = img;
end
end

