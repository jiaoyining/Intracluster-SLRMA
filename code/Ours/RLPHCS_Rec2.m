function [Y,lam,Sigma_Y,k,Sigma_bY] = RLPHCS_Rec2(F, opts)
% =========================================================================
% DESCRIPTION:
% Sparse learning from the observation model F = ADY + N with given D by
% the following objective function:
%        min_{Y} ||Y - F/sqrnp||^2_{diag{lam}} + ||Y||^2_{Sigma_Y} 
%     + log|Sigma_bY| + 1/np * sum_{i} [ k(i) * Sigma_Y(i,i) - 2logk(i)]
% where Sigma_bY = diag(lam) + Sigma_Y;
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

[mb, np] = size(F);
nd = mb;

%% parameter initialization
%%
lam = abs(ones(mb,1));
Y = zeros(nd,np);
Sigma_Y = diag(ones(nd,1));
k = ones(nd,1);
Sigma_bY = diag(lam) + Sigma_Y;

%% sparse learning
%%
d = 1e-5;        % the perturbation variable
iterNum = 0;     % iteration counter
RelChgOut_Y = 1; % the update difference, norm(Y^{n+1} - Y^{n}) / norm(Y)
sqnp = sqrt(np); % sqrt of np

while iterNum < opts.maxIterNum && RelChgOut_Y > opts.tol || iterNum < 1
    Yp = Y;
 
    %1. update Y
    Y = Sigma_Y / Sigma_bY * F ./ sqnp;
   
    %2. update Sigma_Y
    V = (Sigma_Y - Sigma_Y.^2 / Sigma_bY);
    if opts.prior
        s = diag(Y * Y' + V');
        for i = 1 : nd
            tenpv = np^2 + 4 * np * k(i) * s(i);
            Sigma_Y(i,i) = (sqrt(tenpv) - np) * 1.0 / (2 * k(i)); % add the
        end
    else
        Sigma_Y = diag(diag(V' + Y * Y'));
    end
    
    %4. update lam
    agQ = Y -  F ./ sqnp;
    alpha = diag(inv(Sigma_bY));
    %lam = sqrt(diag(agQ * agQ' + d)./ alpha);
    tau = sqrt(trace(agQ * agQ' + d) ./ (sum(alpha) * np));
    lam = ones(mb,1) .* tau;
    %lam = 0.1;
    
    %5. update k
    if opts.prior
        k = 2.0 ./ diag(Sigma_Y);
    end
    
    %6. update other middle variables
    Sigma_bY = diag(lam) + Sigma_Y;
    RelChgOut_Y = norm(Yp.* sqnp - Y .* sqnp,'fro') / norm(Yp .* sqnp,'fro');
    iterNum = iterNum + 1;
    
    if opts.print
        fprintf('iterations %d, update difference %.5f...\n',iterNum,RelChgOut_Y);
    end
end
Y = Y.* sqnp;
end


