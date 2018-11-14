function [Z,mv]    =  load_HSI( image )
% �������ɶ�ά��ʽ����������
sz = size(image);
bands = sz(3);
s_Z = zeros(bands,sz(1)*sz(2));
for band = 1:bands
    Z              =   image(1:sz(1), 1:sz(2),band);
    s_Z(band, :)   =   Z(:);
end
% mv     =  max(s_Z(:));
Z      = s_Z;
% Z      =  s_Z/mv;
end