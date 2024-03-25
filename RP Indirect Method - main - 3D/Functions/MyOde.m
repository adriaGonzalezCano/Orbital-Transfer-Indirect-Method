%% Other Functions - Differential Equations of the Transfer Problem
function dy_dt = MyOde(t, y, YP, thrust, i_arc, pData)
    % y = [r, theta, phi, u, v, w, m, l_r, l_phi, l_u, l_v, l_w, l_m]
    % YP = [tau; l_r; l_theta; l_phi, l_u; l_v; l_w, l_m]
    % Extract Euler-Lagrange variables
    r = y(1);
    theta = y(2);
    phi = y(3);
    u = y(4);
    v = y(5);
    w = y(6);
    m = y(7);
    lambdaR = y(8);
    lambdaTheta = YP(pData.N_arcs + 2);
    lambdaPhi = y(9);
    lambdaU = y(10);
    lambdaV = y(11);
    lambdaW = y(12);

    tau = YP(i_arc);

    Lam = sqrt(lambdaU^2+lambdaV^2+lambdaW^2);
    TM = thrust/y(7);

    dy_dt = zeros(13, 1);

    % Differential equations
    dy_dt(1) = u; % dr_dt

    dy_dt(2) = v/(r*cos(phi)); % dtheta_dt

    dy_dt(3) = w/r; % dphi_dt

    dy_dt(4) = -pData.mu/r^2 + (v^2 + w^2)/r + TM*(lambdaU/Lam); % du_dt

    dy_dt(5) = (-u*v + v*w*tan(phi))/r + TM*(lambdaV/Lam); % dv_dt

    dy_dt(6) = (-u*w - v^2*tan(phi))/r + TM*(lambdaW/Lam); % dw_dt

    dy_dt(7) = -thrust/pData.C; % dm_dt

    dy_dt(8) =  (lambdaTheta*(v/cos(phi)) + lambdaPhi*w + lambdaU*(-2*pData.mu/r...
        + v^2 + w^2) + lambdaV*(-u*v + v*w*tan(phi)) + lambdaW*(-u*w ...
        - v^2*tan(phi)))/r^2; % dl_r_dt

    dy_dt(9) = (-lambdaTheta*v*sin(phi) - lambdaV*v*w + lambdaW*v^2)/...
        (r*cos(phi)^2); % dl_phi_dt

    dy_dt(10) = (-lambdaR*r + lambdaV*v + lambdaW*w)/r; %dl_u_dt

    dy_dt(11) = (-lambdaTheta/cos(phi) - 2*lambdaU*v + lambdaV*(u - w*tan(phi))...
        + 2*lambdaW*v*tan(phi))/r; %dl_v_dt

    dy_dt(12) = (-lambdaPhi - 2*lambdaU*w - lambdaV*v*tan(phi) + ...
        lambdaW*u)/r; %dl_w_dt

    dy_dt(13) = thrust*Lam/m^2; % dl_m_dt

    dy_dt = tau*dy_dt;
end
