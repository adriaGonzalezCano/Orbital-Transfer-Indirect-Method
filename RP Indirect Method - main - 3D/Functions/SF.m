%% Other Functions - Switching Function
function sf = SF(y, C)
    % y = [r, theta, phi, u, v, w, m, l_r, l_phi, l_u, l_v, l_w, l_m]
    m = y(7);
    l_u = y(10);
    l_v = y(11);
    l_w = y(12);
    l_m = y(13);
    
    Lam = sqrt(l_u^2 + l_v^2 + l_w^2);
    
    % Compute switching function
    sf = Lam/m - l_m/C;
end