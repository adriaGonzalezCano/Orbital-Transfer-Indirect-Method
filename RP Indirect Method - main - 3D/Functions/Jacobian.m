%% Other Functions - Jacobian
function Jac = Jacobian(YP, ER, pData)
    % Initialize Jacobian Matrix
    Jac = zeros(pData.K, pData.K);
    
    for i = 1:pData.K
        % Forward diference scheme
        YP_eps = YP;
        YP_eps(i) = YP_eps(i) + pData.eps;
        ER_eps = SHOOTING_FUNCTION(YP_eps, pData, 0);
        Jac(:, i) = (ER_eps - ER) / pData.eps;

        % Central difference scheme
%         YP_eps_inc = YP;
%         YP_eps_dec = YP;
%         YP_eps_inc(i) = YP_eps_inc(i) + pData.eps;
%         YP_eps_dec(i) = YP_eps_dec(i) - pData.eps;
%         [ER_eps_inc,~,~] = SHOOTING_FUNCTION(YP_eps_inc, pData, 0);
%         [ER_eps_dec,~,~] = SHOOTING_FUNCTION(YP_eps_dec, pData, 0);
%         Jac(:, i) = (ER_eps_inc - ER_eps_dec) / (2*pData.eps);
    end
end