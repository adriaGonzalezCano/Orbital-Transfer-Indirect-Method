%% Functions - BOUND
function ER = BOUND(ya, yb, YP, pData)
    % y = [r, theta, phi, u, v, w, m, l_r, l_phi, l_u, l_v, l_w, l_m]
    % YP = [tau; l_r; l_theta; l_phi, l_u; l_v; l_w, l_m]    
    % Define Hamiltonian at t=tf
    % Hf = Hamiltonian(yb(N_arcs, :), YP, mu, Tmax, C, N_arcs); 

    % Define switching function between arcs
    sf = zeros(pData.N_arcs - 1, 1);
    
    for i_arc = 1:pData.N_arcs - 1
        sf(i_arc) = SF(yb(i_arc, :), pData.C);  
    end
    
    % Initialize error(ER)
    ER = zeros(pData.K, 1);
    
    % Compute error (ER)
    ER(1) = yb(pData.N_arcs, 1) - pData.rf_des;             % ER1 = r(tf) - rf_des 
    ER(2) = yb(pData.N_arcs, 2) - pData.thetaf_des;         % ER2 = theta(tf) - thetaf_des   
    ER(3) = yb(pData.N_arcs, 3) - pData.phif_des;           % ER3 = phi(tf) - phif_des
    ER(4) = yb(pData.N_arcs, 4) - pData.uf_des;             % ER4 = u(tf) - uf_des
    ER(5) = yb(pData.N_arcs, 5) - pData.vf_des;             % ER5 = v(tf) - vf_des
    ER(6) = yb(pData.N_arcs, 6) - pData.wf_des;             % ER6 = w(tf) - wf_des
    ER(7) = yb(pData.N_arcs, 13);                           % ER7 = l_m_f
    for i_arc = 1:pData.N_arcs % run through all arcs
        ER(8) = ER(8) + YP(i_arc);                          % ER8 = tf - tf_des
    end
    for i_sp = 1:pData.N_arcs - 1 % run through all switch points
        ER(8 + i_sp) = sf(i_sp);                            % ER8+i = SF|i             
    end
end