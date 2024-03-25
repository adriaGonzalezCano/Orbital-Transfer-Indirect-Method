%% Functions - SHOOTING_FUNCTION
function [ER, yout_all, tout_all] = SHOOTING_FUNCTION(YP, pData, save_data)
    % Implement the logic for simulating and updating ER for each arc
    % This function will be called within the optimization loop
    
    % For each arc:
    % - Set initial conditions based on YP and arc index
    % - Run a simulation (ODE solver) to calculate state vector at arc endpoints
    % - Update ER based on boundary conditions (e.g., final radius, velocity)
    
    % Initialize boundary matrices 
    ya = zeros(pData.N_arcs, pData.NY);
    yb = zeros(pData.N_arcs, pData.NY);
    
    % Initialize cell arrays to store yout and tout for each arc
    yout_all = cell(pData.N_arcs, 1);
    tout_all = cell(pData.N_arcs, 1);

    % Define arcs start and end times
    arc_times = linspace(0, pData.N_arcs, pData.N_arcs + 1);
    
    for i_arc = 1:pData.N_arcs
        % Set initial Y0
        % y0 = [r; theta; u; v; m; l_r; l_u; l_v; l_m]
        % YP = [tau1; tau2; tau3; l_r; l_theta; l_u; l_v; l_m]

        % Initialize y0 and T variables for each arc
        if i_arc == 1
            y0 = [1; 0; 0; 1; 1; YP(pData.N_arcs + 1); YP(pData.N_arcs + 3); ...
                YP(pData.N_arcs + 4); YP(pData.N_arcs + 5)];
        else
            y0 = yb(i_arc - 1, :);
        end

        if mod(i_arc, 2) == 1 % Thrust arc
            T = pData.Tmax;
        else % Coast arc
            T = 0;
        end
        
        % Set Thrust
        thrust = T;
        
        % Numerical Simulation
        %------------------------------------------------------------------
        tspan = linspace(arc_times(i_arc), arc_times(i_arc + 1), pData.nSteps);

        % Options for ode45
        options = odeset('RelTol', 1e-12, 'AbsTol', 1e-12);
        
        % Call ode45 to integrate odes
        [tout, yout] = ode45(@(t, y) MyOde(t, y, YP, thrust, pData, i_arc), tspan, y0, options);
        
        % Get ya and yb
        ya(i_arc, :) = yout(1,:);
        yb(i_arc, :) = yout(end,:); 
        
        % Save yout and tout (if save=True)
        if save_data == 1
            yout_all{i_arc} = yout;
            tout_all{i_arc} = tout;
        end
        %-----------------------------------------------------------------
    end
    % Compute error (ER)
    ER = BOUND(ya, yb, YP, pData);
end