%% Control of the linearized system

params = nparams;
apply_noise = 0;


%% Root locus
% A = [-a,  0, -b*x10;
%       0, -c,  d*x20;
%       0,  0,  e*x10-f*x20];
% B = [0, 0, -1]';
% C = [0, 0, 1];
% D = 0;
% rlocus(ss(A,-B,C,D)), grid;


%% Simulation: nominal case
disp('## Simulation: nominal case ##')

k_p = 11.45;
out = sim('linctrl_k');

transientInfo(out);

% Plot
plot_results(out, 0, 'nominal case')

pauseMsg, close all


%% Simulation: param uncertainties (1)
disp('## Simulation: param uncertainties ##')
params = params_u1;

% Output feedback
out = sim('linctrl_k');
transientInfo(out);
disp('');

% Set parameters back to nominal value
params = nparams;

% Plot
plot_results(out, apply_noise, 'param uncertainties')

pauseMsg, close all


%% Simulation: param uncertainties (2)
disp('## Simulation: big param uncertainties ##')
params = params_u2;

% Output feedback
out = sim('linctrl_k');
transientInfo(out);
disp('');

% Set parameters back to nominal value
params = nparams;

% Plot
plot_results(out, apply_noise, 'big param uncertainties')

pauseMsg, close all


%% Simulation: noise
disp('## Simulation: noise ##')
apply_noise = 1;

% Output feedback
out = sim('linctrl_k');
transientInfo(out);
disp('');

% Plot
plot_results(out, apply_noise, 'with noise')



%% Plots
function plot_results(out, noise, scenario)
    % Viral load
    figure(), grid, hold on
    plot(out.tout, out.z.Data(:,3).*1e4)
    title(['Viral load: ', scenario], 'FontSize', 28)
    xlabel('t [years]', 'FontSize', 26)
    ylabel('copies/ml / 1000', 'FontSize', 26)
    xlim([0 1.5])
    
    % Viral load crossing undetectable
    undetect = find(out.x.Data(:,3) <= 50e-7, 1);
    if(undetect)
        figure(), grid, hold on
        yline(50, 'r--')
        plot(out.tout, out.z.Data(:,3).*1e7)
        title(['Viral load: ', scenario], 'FontSize', 28)
        xlabel('t [years]', 'FontSize', 26)
        ylabel('copies/ml', 'FontSize', 26)
        legend('Non-communicable threshold', 'FontSize', 26)
        tt = out.tout(undetect);
        xlim([max(tt-1.5,0), tt+1.5]), ylim([0, 100])
    end
    
    % Control
    figure(), grid, hold on
    stairs(out.u.Time, out.u.Data)
    title(['Control: ', scenario], 'FontSize', 28)
    xlabel('t [years]', 'FontSize', 26)
    xlim([0 1.5])%, ylim([0 0.06])

    % Full state
    color1 = '#EDB120';
    color2 = '#77AC30';
    color3 = '#7E2F8E';
    figure(), grid, hold on
    plot(out.tout, out.z.Data(:,1), 'Color', color1)
    plot(out.tout, out.z.Data(:,2), 'Color', color2)
    plot(out.y*1e4, 'Color', color3)
    title(['Full state: ', scenario], 'FontSize', 28)
    legend('z_1', 'z_2', 'z_3', 'FontSize', 26)
    xlabel('t [years]', 'FontSize', 26)
    ylabel('cells/mm^3, copies/ml / 1000', 'FontSize', 26)
    
    if noise
        figure(), grid, hold on
        plot(out.noise*1e7)
        title('Noise', 'FontSize', 28)
        xlabel('t [years]', 'FontSize', 26)
        ylabel('copies/ml', 'FontSize', 26)
    end
end
