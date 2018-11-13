function [Y,lam,Sigma_Y,k] = RLPHCS_Cov_Rec(A, D, F, opts, lam0, Y0)
% =========================================================================
% DESCRIPTION:
% Sparse learning from the observation model F = ADY + N with given D by
% the following objective function:
%        min_{Y} ||A*D*Y - F/sqrnp||^2_{diag{lam}} + ||Y||^2_{Sigma_Y} 
%     + log|Sigma_bY| + 1/np * sum_{i} [ k(i) * Sigma_Y(i,i) - 2logk(i)]
% where Sigma_bY = diag(lam) + A*D*Sigma_Y*D'*A';
% -------------------------------------------------------------------------
% INPUT ARGUMENTS:
% A                      random sampling matrix of size [mb,nd]
% D                      given dictionary of size [nd,np]
% F                      noisy measurements of size [mb,np]
% opts                   'maxIterNum', the maximum iteration number
%                        'prior', true  - reweighted Laplace prior
%                                 false - Gaussian prior
%                        'tol', the tolerence of update difference for
%                               stopping iteration
%                        'print', ture  - print iteration inforamtion
%                                 false - not print iteration inforamtion
% -------------------------------------------------------------------------
% OUTPUT ARGUMENTS:
% Y                      sparse representation matrix of size [nd,np]
% lam                    noise variance
% Sigma_Y                prior parameter
% k                      hyperprior parameter
% -------------------------------------------------------------------------
% 

AD = A * D;
[mb, np] = size(F);
[mb,nd] = size(AD);

%% parameter initialization
%%
lam = lam0;
Y = Y0;
Sigma_Y = cov(Y0');
Sigma_bY = diag(lam) + AD * Sigma_Y * AD';

%% sparse learning
%%
d = 1e-5;        % the perturbation variable
iterNum = 0;     % iteration counter
RelChgOut_Y = 1; % the update difference, norm(Y^{n+1} - Y^{n}) / norm(Y)
sqnp = sqrt(np); % sqrt of np

while iterNum < opts.maxIterNum && RelChgOut_Y > opts.tol || iterNum < 1
    
    Yp = Y;
    %2. update Sigma_Y
    V = Sigma_Y - Sigma_Y * AD' / Sigma_bY * AD * Sigma_Y;
    Sigma_Y = (V' + Y * Y'); %eye(nd,nd).*1e-9;
    
    %4. update lam
    agQ = AD * Y -  F ./ sqnp;
    alpha = diag(inv(Sigma_bY));
    lam = sqrt(diag(agQ * agQ' + d)./ alpha);
    
    %6. update other middle variables
    Sigma_bY = diag(lam) + AD * Sigma_Y * AD';
    
    %1. update Y
    tenp = AD' / Sigma_bY;
    Y = Sigma_Y * tenp * F ./ sqnp;
    
    RelChgOut_Y = norm(Yp.* sqnp - Y .* sqnp,'fro') / norm(Yp .* sqnp,'fro');
    iterNum = iterNum + 1;
    
    if opts.print
        fprintf('iterations %d, update difference %.5f...\n',iterNum,RelChgOut_Y);
    end
end
end