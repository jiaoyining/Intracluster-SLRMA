function [ Y ] = CovertTo2D( X)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[row,col,nb] = size(X);
Y = zeros(nb,row * col);
for i = 1 : nb
    img = reshape((X(:,:,i))',row*col,1);
    Y(i,:) = img;
end
end



