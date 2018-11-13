function [ Y ] = CovertTo3D( X,row,col )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[nb,np] = size(X);
Y = zeros(row,col,nb);
for i = 1 : nb
    img = (reshape(X(i,:),row,col))';
    Y(:,:,i) = img;
end
end

