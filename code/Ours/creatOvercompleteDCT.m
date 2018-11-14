function [DCT] = creatOvercompleteDCT(bb,K,dim)
% =========================================================================
% DESCRIPTION:
% Create an DCT dictionary of size [bb,K].
% -------------------------------------------------------------------------
% INPUT ARGUMENTS:
% bb                      dimension of dictionary atom
% K                       number of dictionary atoms
% dim                     1 or 2: 1 denotes 1D DCT atom, 2
%                         denotes 2D DCT atom
% -------------------------------------------------------------------------
% OUTPUT ARGUMENTS:
% DCT                     DCT dictionary of size [bb,K]
% -------------------------------------------------------------------------
% 

if dim ~= 1
    Pn=ceil(sqrt(K));
else
    Pn=ceil(K);
end
DCT=zeros(bb,Pn);
for k=0:1:Pn-1,
    V=cos([0:1:bb-1]'*k*pi/Pn);
    if k>0, V=V-mean(V); end;
    DCT(:,k+1)=V/norm(V);
end;
if dim ~= 1
    DCT=kron(DCT,DCT);
end

end