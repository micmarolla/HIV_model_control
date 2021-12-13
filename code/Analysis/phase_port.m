%% Phase portrait

x0_1 = [x10, x20, 0.0001];  % Nominal condition with some viral load
tf = 20;                    % Simulation time

% Other initial conditions for simulations
x0_2 = [1500 1500/1.5 0.0001];
x0_3 = [700  700/2.2  0.0001];
x0_4 = [400  400      0];
x0_5 = [750  800      0];

% Plot colors
color1 = '#EDB120';
color2 = '#77AC30';
color3 = '#7E2F8E';
color4 = '#0072BD';
color5 = '#D95319';


%% Phase portrait starting from different initial condition
figure(); grid, hold on, view(85,30)
title('Phase portrait', 'FontSize', 28)
xlabel('CD4', 'FontSize', 26), ylabel('CD8', 'FontSize', 26)
zlabel('HIV-1', 'FontSize', 26)

% First sim
[t1,x1] = ode45(@(t,X) modelODE(X,0,params), [0 tf], x0_1);
plot3(x1(:,1), x1(:,2), x1(:,3), 'Color', color1);

% Second sim
[t2,x2] = ode45(@(t,X) modelODE(X,0,params), [0 tf], x0_2);
plot3(x2(:,1), x2(:,2), x2(:,3), 'Color', color2);

% Third sim
[t3,x3] = ode45(@(t,X) modelODE(X,0,params), [0 tf], x0_3);
plot3(x3(:,1), x3(:,2), x3(:,3), 'Color', color3);

% Virus-free sims
[~,x4] = ode45(@(t,X) modelODE(X,0,params), [0 tf], x0_4);
plot3(x4(:,1), x4(:,2), x4(:,3), 'Color', color4);
[~,x5] = ode45(@(t,X) modelODE(X,0,params), [0 tf], x0_5);
plot3(x5(:,1), x5(:,2), x5(:,3), 'Color', color5);

% Points of interest
plot3(x1e, x2e, x3e, 'r*');
plot3(x10, x20, 0, 'o', 'Color', color1);
plot3(x0_2(1), x0_2(2), x0_2(3), 'o', 'Color', color2);
plot3(x0_3(1), x0_3(2), x0_3(3), 'o', 'Color', color3);
plot3(x0_4(1), x0_4(2), x0_4(3), 'o', 'Color', color4);
plot3(x0_5(1), x0_5(2), x0_4(3), 'o', 'Color', color5);

legend('x_0 = [x_{10}, x_{20}, 10^{-4}]^T', ...
    'x_0 = [1500, 1000, 10^{-4}]^T', 'x_0 = [700, 318, 10^{-4}]^T', ...
    'x_0 = [400, 400, 0]^T', 'x_0 = [750, 800, 0]^T', ...
    'Infected equilibrium', 'FontSize', 20)


%% Phase portrait from the three view
figure(), grid, hold on
plot(x1(:,1), x1(:,2), 'Color', color1);
plot(x2(:,1), x2(:,2), 'Color', color2);
plot(x3(:,1), x3(:,2), 'Color', color3);
plot(x10, x20, 'o', 'Color', color1);
plot(x0_2(1), x0_2(2), 'o', 'Color', color2);
plot(x0_3(1), x0_3(2), 'o', 'Color', color3);
plot(x1e, x2e, 'r*');
title('Phase portrait', 'FontSize', 28)
xlabel('CD4', 'FontSize', 26), ylabel('CD8', 'FontSize', 26)

figure(), grid, hold on
plot(x1(:,1), x1(:,3), 'Color', color1);
plot(x2(:,1), x2(:,3), 'Color', color2);
plot(x3(:,1), x3(:,3), 'Color', color3);
plot(x10, 0, 'o', 'Color', color1);
plot(x0_2(1), x0_2(3), 'o', 'Color', color2);
plot(x0_3(1), x0_3(3), 'o', 'Color', color3);
plot(x1e, x3e, 'r*');
title('Phase portrait', 'FontSize', 28)
xlabel('CD4', 'FontSize', 26), ylabel('HIV-1', 'FontSize', 26)

figure(), grid, hold on
plot(x1(:,2), x1(:,3), 'Color', color1);
plot(x2(:,2), x2(:,3), 'Color', color2);
plot(x3(:,2), x3(:,3), 'Color', color3);
plot(x20, 0, 'o', 'Color', color1);
plot(x0_2(2), x0_2(3), 'o', 'Color', color2);
plot(x0_3(2), x0_3(3), 'o', 'Color', color3);
plot(x2e, x3e, 'r*');
title('Phase portrait', 'FontSize', 28)
xlabel('CD8', 'FontSize', 26), ylabel('HIV-1', 'FontSize', 26)


%% Plot of CD4/CD8
figure(), grid, hold on
xlabel('t [years]', 'FontSize', 26), ylabel('CD4/CD8', 'FontSize', 26)
title('CD4/CD8 ratio with healthy region', 'FontSize', 28)
plot(t1, x1(:,1)./x1(:,2), 'Color', color1)
plot(t2, x2(:,1)./x2(:,2), 'Color', color2)
plot(t3, x3(:,1)./x3(:,2), 'Color', color3)
yline(1.2, 'r--'), yline(2.2, 'r--')

%% Plot of full state CD4, CD8, HIV evolution
figure(), grid, hold on
title('State evolution with x_0 = [x_{10}, x_{20}, 10^{-4}]^T', 'FontSize', 28)
plot(t1, x1(:,1)), plot(t1, x1(:,2)), plot(t1, 1e4*x1(:,3))
xlabel('t [years]', 'FontSize', 26)
ylabel('cells/mm^3, copies/ml / 1000', 'FontSize', 26)
legend('CD4', 'CD8', 'HIV-1', 'FontSize', 26)
