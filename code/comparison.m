%% Comparison between controllers

params = nparams;
apply_noise = 0;


%% Controllers gains
% Proportional
k_p = 11.45;

% Feedback linearization
k_fbl = 4.35;

% Adaptive
k_apt = 12;
ke_apt = 1e-5;
kf_apt = 1e-5;

% Gain locking (control works fine without it)
error_thresh = 1.5e-5;
gain_locking = 0;


%% Open-loop simulation for comparison
[t_ol,x_ol] = ode45(@(t,X) modelODE(X,0,params), [0 tf], x0);
openloop.t = t_ol;
openloop.z = zeros(size(x_ol));
openloop.z(:,1) = x_ol(:,1) - x10;
openloop.z(:,2) = x_ol(:,1) - x20;
openloop.z(:,3) = x_ol(:,3);

%% Nominal case
disp('=== Comparison in nominal case ===')

params = nparams;
outs = compare();
plot_results(outs, 0, 'nominal case');

pauseMsg, close all
disp('---------------------------------')

%% Param uncertainties
disp('=== Comparison with parameter uncertainty ===')
params = params_u1;

outs = compare();
plot_results(outs, 0, 'param uncertainties');

params = nparams;

pauseMsg, close all
disp('---------------------------------')


%% Big param uncertainties
disp('=== Comparison with big parameter uncertainty ===')
params = params_u2;

outs = compare();
plot_results(outs, 0, 'big param uncertainties');

params = nparams;

pauseMsg, close all
disp('---------------------------------')


%% Noise
disp('=== Comparison with noise ===')
apply_noise = 1;
outs = compare();
plot_results(outs, 1, 'with noise');



%% Simulation
function outs = compare
    % Linear control: output feedback
    disp('Simulating output feedback...')
    out_k = sim('linctrl_k');
    transientInfo(out_k);
    disp(' ')
   
    % Feedback linearization
    disp('Simulating feedback linearization...')
    out_fbl = sim('fbl_ctrl');
    transientInfo(out_fbl);
    disp(' ')

    % Adaptive
    disp('Simulating adaptive feedback linearization...')
    out_apt = sim('ad_fbl_ctrl');
    transientInfo(out_apt);
    disp(' ')

    outs = [out_k out_fbl out_apt];
end


%% Plots
function plot_results(outs, noise, scenario)
    out_k = outs(1); out_fbl = outs(2); out_apt = outs(3);

    % Viral load
    figure(), grid, hold on
    plot(out_k.y   * 1e4)
    plot(out_fbl.y * 1e4)
    plot(out_apt.y * 1e4)
    legend('P', 'FBL', 'Adaptive', 'FontSize', 26)
    title(['Viral load: ', scenario], 'FontSize', 28)
    xlabel('t [years]', 'FontSize', 26)
    ylabel('copies/ml / 1000', 'FontSize', 26)
    if ~strcmp(scenario, 'big param uncertainties')
        xlim([0 1.5])
        ylim([0 6])
    end

    % Control
    figure(), grid, hold on
    stairs(out_k.u.Time, out_k.u.Data)
    stairs(out_fbl.u.Time, out_fbl.u.Data)
    stairs(out_apt.u.Time, out_apt.u.Data)
    title(['Control: ', scenario], 'FontSize', 28)
    legend('P', 'FBL', 'Adaptive', 'FontSize', 26)
    xlabel('t [years]', 'FontSize', 26)
    if ~strcmp(scenario, 'big param uncertainties')
        xlim([0 1.5])
    end

    % CD4 count
    figure(), grid, hold on
    plot(out_k.tout, out_k.z.Data(:,1))
    plot(out_fbl.tout, out_fbl.z.Data(:,1))
    plot(out_apt.tout, out_apt.z.Data(:,1))
    legend('P', 'FBL', 'Adaptive', 'FontSize', 26)
    title(['CD4 count: ', scenario], 'FontSize', 28)
    xlabel('t [years]', 'FontSize', 26)
    ylabel('cells/mm^3', 'FontSize', 26)
    
    % CD8 count
    figure(), grid, hold on
    plot(out_k.tout, out_k.z.Data(:,2))
    plot(out_fbl.tout, out_fbl.z.Data(:,2))
    plot(out_apt.tout, out_apt.z.Data(:,2))
    legend('P', 'FBL', 'Adaptive', 'FontSize', 26)
    title(['CD8 count: ', scenario], 'FontSize', 28)
    xlabel('t [years]', 'FontSize', 26)
    ylabel('cells/mm^3', 'FontSize', 26)
    
    % Parameter estimation
    figure(), grid, hold on
    plot(out_apt.e_hat), plot(out_apt.f_hat)
    title(['Parameters estimation: ', scenario], 'FontSize', 28)
    legend('$\hat{e}$', '$\hat{f}$', 'FontSize', 26, 'Interpreter', 'Latex')
    xlabel('t [years]', 'FontSize', 26)
    xlim([0 1])
    if strcmp(scenario, 'big param uncertainties')
        xlim([0 10])
    end
    
    % Noise
    if noise
        figure(), grid, hold on
        plot(out_fbl.noise*1e7)
        title('Noise', 'FontSize', 28)
        xlabel('t [years]', 'FontSize', 26)
        ylabel('copies/ml', 'FontSize', 26)
    end
end