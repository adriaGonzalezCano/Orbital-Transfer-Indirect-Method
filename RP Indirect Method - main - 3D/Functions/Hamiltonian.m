%% Other Functions - Hamiltonian
function H = Hamiltonian(y, YP, mu, Tmax, C, N_arcs)
    % y = [r, theta, phi, u, v, w, m, l_r, l_phi, l_u, l_v, l_w, l_m]
    % YP = [tau; l_r; l_theta; l_phi, l_u; l_v; l_w, l_m]
    r = y(1);
    phi = y(3);
    u = y(4);
    v = y(5);
    w = y(6);
    l_r = y(8);
    l_theta = YP(N_arcs + 2);
    l_phi = y(9);
    l_u = y(10);
    l_v = y(11);
    l_w = y(12);
    
    lambda_R = [l_r; l_theta/(r*cos(phi)); l_phi/r]; % Different from Zavoli!!
    lambda_V = [l_u; l_v; l_w];
    
    V = [u; v; w];
    G = [-mu/r^2 + (v^2 + w^2)/r; (-u*v + v*w*tan(phi))/r; ...
        (-u*w - v^2*tan(phi))/r];
    
    % Compute switching function
    sf = SF(y, C);
    
    % Evaluate beta with switching function
    if sf > 0
        beta = 1;
    elseif sf < 0 || sf == 0
        beta = 0;
    end
    
    % Compute Hamiltonian
    % H = lambda_R'*V + lambda_V'*G + beta*Tmax*sf;
    H = lambda_R'*V + lambda_V'*G + beta*Tmax*sf;
end