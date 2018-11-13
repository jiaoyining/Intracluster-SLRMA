function [ Y ] = CovertTo2D( X)

%Convet the 3D matrix X of size [row, col, band] into a 2D matrix of size  [band, row * col]

[row,col,nb] = size(X);
Y = zeros(nb,row * col);
for i = 1 : nb
    img = reshape(X(:,:,i),row * col,1);
    Y(i,:) = img;
end
end



