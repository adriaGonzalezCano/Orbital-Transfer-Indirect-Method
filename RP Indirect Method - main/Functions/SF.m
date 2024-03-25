%% Other Functions - Switching Function
function sf = SF(y, C)
    % y = [r, theta, u, v, m, l_r, l_u, l_v, l_m]
    m = y(5);
    l_u = y(7);
    l_v = y(8);
    l_m = y(9);
    
    Lam = sqrt(l_u^2 + l_v^2);
    
    % Compute switching function
    sf = Lam/m - l_m/C;
end