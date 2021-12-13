%% HIV-1: main script
% This defines all the necessary variables.
% Uncomment the script you want to execute at the end of this file.


%% Model parameters
a = 0.25;
b = 50;
c = 0.25;
d = 10;
e = 0.01;
f = 0.0045;
x10 = 1000;
x20 = 550;
params = [a b c d e f x10 x20];


%% Parameter sets
nparams = params;   % Nominal parameters

params_u1 = params;  % 5% parameter uncertainty
params_u1(5) = e * 1.05;  % e
params_u1(6) = f * 0.95;  % f

params_u2 = params;  % 35% parameter uncertainty
params_u2(5) = e * 1.35;  % e
params_u2(6) = f * 0.65;  % f


%% Infected equilibrium
x1e = (a*d*e*x10+b*c*f*x20)/(e*(a*d+b*c));
x2e = (a*d*e*x10+b*c*f*x20)/(f*(a*d+b*c));
x3e = (a*c*(e*x10-f*x20)) / (a*d*e*x10+b*c*f*x20);


%% Simulation parameters
x0 = [950; 550; 6e-4];  % Initial condition
r = 0;                  % Reference
tf = 30;                % Simulation time [years]
Ts = 0.02;              % Control sample time [in years] (= 1 week)

% Noise parameters
noise_a = -20e-7;
noise_b = -50e-7;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select which script you want to execute:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Draw the phase portrait of the system
%phase_port
%
% Simulation for negative alpha (the immunitary response beat the virus)
%sim_a_neg
%
% Linear proportional control
%linear_control
%
% IO feedback linearization control
%fbl
%
% Adaptive fbl control
%ad_fbl
%
% Controller comparison
comparison


