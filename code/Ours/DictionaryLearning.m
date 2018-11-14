function [D] = DictionaryLearning(rX)
CovX = cov(rX');
[P,V] = eig(CovX);
V=diag(V);
[t,ind]=sort(-V);
P = P(:,ind);
D = P;
end
