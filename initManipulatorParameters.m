% Sample Time
Ts = 0.025;  % change to 0.025

% Simulation Time
Tf = 2;

max_t = 0.5e2;

max_w1 = 1.47e3;
max_w2 = 2.74e3;
max_w3 = 1.53e4;
max_w4 = 5.43e4;

time_weight = 19.933 / Ts;

% model saved as xml
manipulator_6dof_DataFile

%% Define limits on variables
% vars for isDone 

