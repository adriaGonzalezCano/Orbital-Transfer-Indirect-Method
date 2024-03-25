%% Planar Planetary Transfer Problem
clear all
clc

%% Include 
addpath('Functions')

%% Constants Definition
% Dynamics parameters
pData.mu = 1;
% Q = 2; % Fuel flux 
% Q = 1;
% C = 0.3;
% Tmax = C*Q; % Maximum thrust
pData.C = 1; % Specific gas velocity
pData.Tmax = 0.01;

% Optimization parameters
pData.eps = 1e-05; % Epsilon value for finite differences
pData.Jmax = 1000000; % Maximum number of optimization iterations
pData.tol = 1e-06; % Convergence limit for error
pData.nSteps = 100; % Number of steps used in the integration
pData.Rmin = 1e-03; % Rmin used for convergence
pData.Pbis = 2; % Bisection method
pData.dt = 1e-4;

% Initialize problem dimensions
pData.NY = 9; % Number of differential equations
pData.N_arcs = 3; % Number of arcs;
pData.IC = 4; % Initial unknown conditions
pData.KP = pData.N_arcs + 1; % Unknown parameters (tau, lambda_theta0)
pData.K = pData.IC + pData.KP; % Scalar Unknowns (parameters + initial unknown conditions

% Transfer parameters
% rf_des = 1.523679; % Mars Desired final radius
pData.rf_des = 1.5;
pData.vf_des = sqrt(1/pData.rf_des); % Desired final velocity

%% Problem initialization
% Define Initial Guess YP
YP = [0.080428973;      % tau_1; 
      4.50349;          % tau_2
      0.061988321;      % tau_3
      1.6380481;        % l_r; 
      0;                % l_theta; 
      -0.00011803349;   % l_u;
      2.6666671;        % l_v;
      1];               % l_m

%% OPTIMIZATION
[YP_opt, ER_data, yout_opt, tout_opt, iter] = OPTIMIZATION(YP, pData);

%% TRAJECTORY ANALYSIS
[DV_total, Time] = Analysis(yout_opt, YP_opt, pData);

%% DISPLAY RESULTS
Display(ER_data, YP_opt, yout_opt, tout_opt, iter, pData);
