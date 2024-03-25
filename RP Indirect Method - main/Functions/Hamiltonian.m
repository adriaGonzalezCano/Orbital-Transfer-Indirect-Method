%% Other Functions - Hamiltonian
function H = Hamiltonian(y, YP, pData)
    % y = [r, theta, u, v, m, l_r, l_u, l_v, l_m]
    % YP = [tau; l_r; l_theta; l_u; l_v; l_m]
    r = y(1);
    u = y(3);
    v = y(4);
    l_r = y(6);
    l_theta = YP(pData.N_arcs + 2);
    l_u = y(7);
    l_v = y(8);
    
    lambda_R = [l_r; l_theta/r];
    lambda_V = [l_u; l_v];
    
    V = [u; v];
    G = [-pData.mu/r^2 + v^2/r; -(u*v)/r];
    
    % Compute switching function
    sf = SF(y, pData.C);
    
    % Evaluate beta with switching function
    if sf > 0
        beta = 1;
    elseif sf < 0 || sf == 0
        beta = 0;
    end
    
    % Compute Hamiltonian
    H = lambda_R'*V + lambda_V'*G + beta*pData.Tmax*sf;
end