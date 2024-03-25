%% Other Functions - Differential Equations of the Transfer Problem
function dy_dt = MyOde(t, y, YP, thrust, pData, i_arc)
    % y = [r, theta, u, v, m, l_r, l_u, l_v, l_m]
    % YP = [tau; l_r; l_theta; l_u; l_v; l_m]
    tau = YP(i_arc);
    lambdaR = y(6);
    lambdaTheta = YP(pData.N_arcs + 2);
    lambdaU = y(7);
    lambdaV = y(8);
    Lam = sqrt(lambdaU^2+lambdaV^2);
    TM = thrust/y(5);

    dy_dt = zeros(9, 1);

    % Differential equations
    dy_dt(1) = y(3); % dr_dt
    
    dy_dt(2) = y(4)/y(1); % dtheta_dt
    
    dy_dt(3) = -pData.mu/y(1)^2+y(4)^2/y(1) + TM*(lambdaU/Lam); % du_dt
    
    dy_dt(4) = -(y(3)*y(4))/y(1) + TM*(lambdaV/Lam); % dv_dt
    
    dy_dt(5) = -thrust/pData.C; % dm_dt
    
    dy_dt(6) = lambdaTheta*y(4)/y(1)^2 - 2*lambdaU*pData.mu/y(1)^3 ...
        + lambdaU*y(4)^2/y(1)^2 - lambdaV*y(3)*y(4)/y(1)^2; % dl_r_dt
    
    dy_dt(7) = -lambdaR + (lambdaV*y(4))/y(1); % dl_u_dt
    
    dy_dt(8) = -lambdaTheta/y(1) - 2*lambdaU*y(4)/y(1) ...
        + lambdaV*y(3)/y(1); % dl_v_dt
    
    dy_dt(9) = thrust*Lam/y(5)^2; % dl_m_dt
    
    dy_dt = tau*dy_dt;  
end
