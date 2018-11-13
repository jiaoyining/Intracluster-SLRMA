function [Fk,index_k,numk] =  SubClassExtract(F,Flag,k)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[mb,np] = size(F);
index_k = zeros(np,1);
Fk = zeros(mb,np);
j = 1;
for i = 1 : np
    if Flag(i) == k
        Fk(:,j) = F(:,i);
        index_k(j) = i;
        j = j + 1;
    end
end
index_k(j:np) = [];
Fk(:,j:np) = [];
numk = j - 1;
end

