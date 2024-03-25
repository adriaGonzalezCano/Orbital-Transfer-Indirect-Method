%% Other Functions - Display_var
function Display_var(variable_name, yout_opt, tout_opt, YP_opt, pData)
    % Initialize cell arrays to store variable values for each arc
    variable_values = cell(length(yout_opt), 1);

    % Create an array to store the cumulative duration of each arc
    cumulative_time = cumsum(YP_opt);

    figure

    % Plot the variable for each arc
    for i_arc = 1:length(variable_values)
        variable_index = strcmp(variable_name, {'r', '\theta', 'u', 'v', 'm', '\lambda_r', '\lambda_u', '\lambda_v', '\lambda_m'});
        variable_arc = yout_opt{i_arc}(:, variable_index); % Extract the variable values
        if mod(i_arc, 2) == 1 
            color = 'r';
        else
            color = 'b';
        end
        plot((tout_opt{i_arc} - i_arc) * YP_opt(i_arc) + cumulative_time(i_arc), variable_arc, color, 'LineWidth', 1.5);
        hold on
    end

    % Create legend entries for arcs
    legend_entries = cell(1, length(variable_values));
    for i_arc = 1:length(variable_values)
        if mod(i_arc, 2) == 1
            legend_entries{i_arc} = 'Thrust Arc ';
        else
            legend_entries{i_arc} = 'Coast Arc ';
        end
    end

    % Label the arcs in the legend
    legend(legend_entries, 'Interpreter', 'latex'); % Use LaTeX interpreter for legend
    xlabel('$Time\ t\ [-]$', 'Interpreter', 'latex'); % LaTeX formatted xlabel
    ylabel(['$' variable_name '\ [-]$'], 'Interpreter', 'latex'); % LaTeX formatted ylabel
    title(['$' variable_name '\ vs.\ Time$'], 'Interpreter', 'latex'); % LaTeX formatted title
    xlim([0, YP_opt(pData.N_arcs) + sum(YP_opt(1:pData.N_arcs-1))]);
    grid on
end