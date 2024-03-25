%% Geo-Transfer Problem
clear all
clc

%% Include 
addpath('Functions')

%% Constants Definition
pData.mu = 1;
% Q = 2; % Fuel flux 
% Q = 1;
% C = 0.3;
% Tmax = C*Q; % Maximum thrust
pData.C = 1; % Specific gas velocity
% Tmax = 0.1;
pData.eps = 1e-05; % Epsilon value for finite differences
pData.Jmax = 1000000; % Maximum number of optimization iterations
pData.tol = 1e-06; % Convergence limit for error
pData.nSteps = 100; % Number of steps used in the integration
pData.Rmin = 1e-03; % Rmin used for convergence
pData.Pbis = 2; % Bisection method
pData.dt = 1e-4;

% Initialize problem parameters
pData.NY = 9; % Number of differential equations
pData.KP = 4; % Unknown parameters (tau1, tau2, tau3, lambda_theta0)
pData.K = 8; % Scalar Unknowns (parameters + initial unknown conditions)
pData.N_arcs = 3; % Number of arcs;

% Transfer parameters
% rf_des = 1.523679; % Mars Desired final radius
pData.rf_des = 1.5;
pData.vf_des = sqrt(1/pData.rf_des); % Desired final velocity

%% Problem initialization
% Define Initial Guess YP
YP_opt = [0.080428973;      % tau_1; 
      4.50349;          % tau_2
      0.061988321;      % tau_3
      1.6380481;        % l_r; 
      0;                % l_theta; 
      -0.00011803349;   % l_u;
      2.6666671;        % l_v;
      1];               % l_m

% Initialize data arrays
YP_opt_data = zeros(pData.K, 100);
yout_opt_data = cell(100, 1);
tout_opt_data = cell(100, 1);

i = 1;
iter_count = 0;

%% Continuation Method
for Tmax = linspace(0.1, 10, 50)
    pData.Tmax = Tmax;
    
    % OPTIMIZATION
    [YP_opt, ~, yout_opt, tout_opt, iter] = OPTIMIZATION(YP_opt, pData);
    
    % Store data in arrays
    YP_opt_data(:, i) = YP_opt;
    yout_opt_data{i} = yout_opt;
    tout_opt_data{i} = tout_opt;
    
    iter_count = iter_count + iter;
    i = i + 1;
end

% Save the workspace in the Transfer_data folder
save('Transfer_data/problem_transfer_earth2mars_continuation.mat');

%% TRAJECTORY ANALYSIS for Tmax = 10
[DV_total, Time] = Analysis(yout_opt_data{50}, YP_opt_data(:, 50), pData);

%% Display results for Tmax = 10 (comment error graph in Display function)
Display([], YP_opt_data(:, 50), yout_opt_data{50}, tout_opt_data{50}, [], pData)