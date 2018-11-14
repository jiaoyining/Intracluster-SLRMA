function [ Y ] = CovertTo3D( X,row,col )
% =========================================================================
% DESCRIPTION:
% Transfrom the 2D HSI into a 3D tensor.
% -------------------------------------------------------------------------
% INPUT ARGUMENTS:
% X                       2D HSI of size [band number, pixel number]
% row                     width of band image
% col                     height of band image
% -------------------------------------------------------------------------
% OUTPUT ARGUMENTS:
% Y                       3D HSI
% -------------------------------------------------------------------------
% 
[nb,np] = size(X);
Y = zeros(row,col,nb);
for i = 1 : nb
    img = (reshape(X(i,:),row,col))';
    Y(:,:,i) = img;
end
end

