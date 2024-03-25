%% Functions - BOUND
function ER = BOUND(ya, yb, YP, pData)
    % y = [r, theta, u, v, m, l_r, l_u, l_v, l_m]
    % YP = [tau; l_r; l_theta; l_u; l_v; l_m]
    
    % Define Hamiltonian at t=tf
    Hf = Hamiltonian(yb(pData.N_arcs, :), YP, pData); 

    % Define switching function between arcs
    sf = zeros(pData.N_arcs - 1, 1);
    
    for i_arc = 1:pData.N_arcs
        sf(i_arc) = SF(yb(i_arc, :), pData.C);  
    end
    
    % Initialize error(ER)
    ER = zeros(pData.K, 1);
    
    % Compute error (ER)
    ER(1) = yb(pData.N_arcs, 1) - pData.rf_des;     % ER1 = r(tf) - rf_des    
    ER(2) = YP(pData.N_arcs + 2);                   % ER2 = l_theta_f (ct)        
    ER(3) = yb(pData.N_arcs, 3);                    % ER3 = u(tf)             
    ER(4) = yb(pData.N_arcs, 4) - pData.vf_des;     % ER4 = v(tf) - vf_des    
    ER(5) = yb(pData.N_arcs, 9) - 1;                % ER5 = l_m_f - 1         
    ER(6) = Hf;                                     % ER6 = Hf 
    for i_arc = 1:pData.N_arcs - 1
        ER(6 + i_arc) = sf(i_arc);                  % ER6+i = SF|i             
    end
end