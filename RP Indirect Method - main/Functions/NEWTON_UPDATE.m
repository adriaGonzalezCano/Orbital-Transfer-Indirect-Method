%% Functions - NEWTON_UPDATE
function [YP_NEW, ER_NEW] = NEWTON_UPDATE(YP, ER, pData)
    % Update YP using the Newton-Raphson method
    % YP_new = YP - Rmin * inv(J) * ER
    
    % Compute the jacobian
    Jac = Jacobian(YP, ER, pData);
    
    % Compute condition number (should be between 0 and 1e4)
    condNumber = cond(Jac);
    disp(['Condition Number: ', num2str(condNumber)]);
    disp(' ')
    
    % Compute new YP vector (YP_NEW)
    YP_NEW = YP - pData.Rmin * inv(Jac)*ER;
    
    % Compute new error vector (ER_NEW)
    [ER_NEW,~,~] = SHOOTING_FUNCTION(YP_NEW, pData, 0); 
    
    % Apply bisection technique
    kbis = 0; % Number of bisection steps
    while max(abs(ER_NEW)) > pData.Pbis*max(abs(ER))
        kbis = kbis + 1;
        fprintf('Active Bisection: ')
        YP_NEW = YP - pData.Rmin * inv(Jac) * ER * (0.5^kbis);
        [ER_NEW,~,~] = SHOOTING_FUNCTION(YP_NEW, pData, 0);
        fprintf('New error: %4f, kbis: %i\n',norm(ER_NEW), kbis);
    end
end