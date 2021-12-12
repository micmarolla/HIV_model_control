%% Simulation for e*x10 - f*x20 < 0

% Set param
params(6) = 0.02;   % e*x10-f*x20 = -1

% Simulate
x0n = [x10, x20, 0.05];
tfn = 25;
[t1,x1] = ode45(@(t,X) modelODE(X,0,params), [0 tfn], x0n);

% Restore nominal parameters
params = nparams;

% Plot
figure(), grid, hold on
plot(t1, x1(:,1)-x10), plot(t1, x1(:,2)-x20), plot(t1, x1(:,3)*1e4)
legend('z_1', 'z_2', 'z_3', 'FontSize', 26)
title('State evolution for \alpha < 0, x_0 = [x_{10}, x_{20}, 0.05]^T', 'FontSize', 28)
xlabel('t [years]', 'FontSize', 26)
ylabel('cells/mm^3, copies/ml / 1000', 'FontSize', 26)