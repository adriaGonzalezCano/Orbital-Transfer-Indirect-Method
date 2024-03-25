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
pData.Tmax = 0.1;
pData.eps = 1e-05; % Epsilon value for finite differences
pData.Jmax = 1000000; % Maximum number of optimization iterations
pData.tol = 1e-05; % Convergence limit for error
pData.nSteps = 100; % Number of steps used in the integration
pData.Rmin = 1e-05; % Rmin used for convergence
pData.Pbis = 2; % Bisection method
pData.dt = 1e-4;

% Initialize problem parameters
pData.NY = 13; % Number of differential equations
pData.N_arcs = 3; % Number of arcs;
pData.IC = 6; % Initial unknown conditions
pData.KP = pData.N_arcs + 1; % Unknown parameters (tau, lambda_theta0)
pData.K = pData.IC + pData.KP; % Scalar Unknowns (parameters + initial unknown conditions

% Transfer parameters
pData.rf_des = 1.2; % Desired final radius
pData.thetaf_des = 3.51098;
pData.phif_des = 0;
pData.uf_des = 0;
pData.vf_des = sqrt(1/pData.rf_des);
pData.wf_des = 0;
pData.tf_des = 4.0417;

%% Problem initialization
% Define Initial Guess YP
YP = [0.080428973;      % tau_1 
      4.50349;          % tau_2
      0.061988321;      % tau_3
      1.6380481;        % l_r; 
      0;                % l_theta; 
      0.03;             % l_phi
      -0.00011803349;   % l_u;
      2.6666671;        % l_v;
      1.9;              % l_w
      1];               % l_m

%% OPTIMIZATION
[YP_opt, ER_data, yout_opt, tout_opt, iter] = OPTIMIZATION(YP, pData);

%% TRAJECTORY ANALYSIS
[DV_total, Time] = Analysis(yout_opt, YP_opt, pData);

%% DISPLAY RESULTS
Display([], YP_opt, yout_opt, tout_opt, iter, pData);