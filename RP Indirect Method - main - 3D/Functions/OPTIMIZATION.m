%% Functions - OPTIMIZATION
function [YP_opt, ER_data, yout_opt, tout_opt, iter] = OPTIMIZATION(YP, pData)
    % Initialization Check
    if length(YP) ~= pData.K
    error('Error: Length of YP must be equal to K');
    end

    % Initialize Iteration Counter
    iter = 1;
    
    % Shoot first ER reference value
    [ER,~,~] = SHOOTING_FUNCTION(YP, pData, 0);
    
    % Initialize ER_data array
    ER_data = [];
    ER_data(1) = norm(ER);

    while norm(ER) > pData.tol && iter < pData.Jmax
        % 1. Call Call NEWTON_UPDATE to update ER and YP
        % 2. Compute Jacobian Matrix (NEWTON_UPDATE)
        % 3. Update YP using Newton-Raphson update
        % YP_new = YP - Rmin * inv(J) * ER
        % 4. Call SHOOTING_FUNCTION to update ER and iter for convergence check    

        % Call NEWTON_UPDATE
        [YP_NEW, ER_NEW] = NEWTON_UPDATE(YP, ER, pData);

        % Update
        ER = ER_NEW;    
        YP = YP_NEW;
        iter = iter + 1;

       % ER_data(iter) = norm(ER);
       % YP_data(iter,:) = YP;

        % Display    
        fprintf('Tmax: %0.2f, Iteration %d, Error: %10.4f\n', pData.Tmax, iter, norm(ER));

        % Display YP and ER side by side
        fprintf('YP:\t');
        for i = 1:numel(YP)
            fprintf('%10.4f\t', YP(i));
        end
        fprintf('\n')
        fprintf('ER:\t');
        for i = 1:numel(YP)
            fprintf('%10.4f\t', ER(i));
        end
        fprintf('\n'); 
    end
    fprintf("End of optimization\n");

    % Save Optimal Trajectory
    YP_opt = YP;
    [~, yout_opt, tout_opt] = SHOOTING_FUNCTION(YP_opt, pData, 1);
end