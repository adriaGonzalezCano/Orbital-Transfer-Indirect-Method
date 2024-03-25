%% Functions - Display
function Display(ER_data, YP_opt, yout_opt, tout_opt, iter, pData)
    disp('Displaying results...')

%     %% 1. Display - Error
%     figure
%     iterations = linspace(1,iter,iter);
%     plot(iterations, ER_data,'b', 'LineWidth', 1.5)
%     xlabel('Iterations', 'Interpreter', 'latex')
%     ylabel('Error', 'Interpreter', 'latex')
%     title('Error\ Convergence', 'Interpreter', 'latex')
%     grid on

    %% 2. Display - Switching Function vs Time
    % Initialize cell arrays to store sf values for each arc
    sf_values = cell(pData.N_arcs, 1);

    % Calculate sf values for each arc and store them
    for i_arc = 1:pData.N_arcs
        yout_arc = yout_opt{i_arc};
        sf_arc = zeros(size(yout_arc, 1), 1);
        for i_point = 1:size(yout_arc, 1)
            sf_arc(i_point) = SF(yout_arc(i_point, :), pData.C);
        end
        sf_values{i_arc} = sf_arc;
    end

    % Create an array to store the cumulative duration of each arc
     cumulative_time = zeros(1, pData.N_arcs);
    for i_arc = 1:pData.N_arcs
        cumulative_time(i_arc) = sum(YP_opt(1:i_arc));
    end
    
    % Plot Switching Function vs Time
    figure

    % Iterate through arcs
    for i_arc = 1:pData.N_arcs
        % Define colors for thrust and coast arcs
        if mod(i_arc, 2) == 1
            % Odd arcs are burn arcs
            line_color = 'r';
            arc_label = ['Burn Arc ' num2str(i_arc)];
        else
            % Even arcs are coast arcs
            line_color = 'b';
            arc_label = ['Coast Arc ' num2str(i_arc)];
        end
        
        % Plot the switching function for the current arc
        plot((tout_opt{i_arc} - (i_arc-1)) * YP_opt(i_arc) + sum(YP_opt(1:i_arc-1)), ...
            sf_values{i_arc}, line_color, 'LineWidth', 1.5, 'DisplayName', arc_label);
        hold on
    end
    
    % Label the arcs in the legend
    legend('Interpreter', 'latex'); % Use LaTeX interpreter for legend
    xlabel('Time\ t\ [-]', 'Interpreter', 'latex')
    ylabel('Switching\ Function\ (SF)', 'Interpreter', 'latex')
    title('Switching\ Function\ vs.\ Time', 'Interpreter', 'latex');
    xlim([0, YP_opt(pData.N_arcs) + sum(YP_opt(1:pData.N_arcs-1))]);
    grid on

    %% 3. Display - variables
    variable_names = {'r', '\theta','\varphi', 'u', 'v','w', 'm', '\lambda_r', '\lambda_\varphi', '\lambda_u', '\lambda_v', '\lambda_w', '\lambda_m'};

    % Iterate through variable names and call Display for each variable
    for i = 1:numel(variable_names)
        variable_name = variable_names{i};
        Display_var(variable_name, yout_opt, tout_opt, YP_opt, pData);
    end

    %% 4. Display - Trajectory
    figure
    % Plot initial and final orbit
    range = 0:0.01:2*pi;
    polarplot(range, ones(size(range)), 'k', 'LineWidth', 1, 'DisplayName', 'Initial Orbit');
    hold on
    polarplot(range, pData.rf_des*ones(size(range)), 'k--', 'LineWidth', 1, 'DisplayName', 'Final Orbit');

    % Iterate through arcs
    for i_arc = 1:pData.N_arcs
        % Extract data for the current arc
        yout_arc = yout_opt{i_arc};
        r_arc = yout_arc(:, 1);
        theta_arc = yout_arc(:, 2);

        % Define colors for thrust and coast arcs
        if mod(i_arc, 2) == 1
            % Odd arcs are thrust arcs
            line_color = 'r';
            arc_label = 'Thrust Arc ';
        else
            % Even arcs are coast arcs
            line_color = 'b';
            arc_label = 'Coast Arc ';
        end

        % Plot the trajectory for the current arc
        polarplot(theta_arc, r_arc, line_color, 'LineWidth', 1.5, 'DisplayName', arc_label);
        hold on
    end

    % Label the arcs in the legend
    legend('Interpreter', 'latex'); % Use LaTeX interpreter for legend
    title('Spacecraft Trajectory', 'Interpreter', 'latex'); % LaTeX formatted title
    grid on
end