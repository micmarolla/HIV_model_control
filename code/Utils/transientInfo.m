%% Print info about CD4, viral load and control action time evolution

function transientInfo(out)
    % HIV made undetectable
    undetect = find(out.x.Data(:,3) <= 50e-7, 1);
    if(undetect)
        und_t = out.tout(undetect);
        disp(['Viral load under threshold at time t = ', num2str(und_t), ...
            '; after ', num2str(und_t*12), ' months of treatment']);
        
        % Settling time
        s = stepinfo(out.z.Data(:,1), out.tout, 0, 'SettlingTimeThreshold', 0.05);
        disp(['CD4 5% settling time: ', num2str(s.SettlingTime), ' years']);
    else
        disp('Viral load cannot be nullified.')
    end
    disp(['Steady-state viral load: ', num2str(out.x.Data(end,3))])
    disp(['Steady-state lymphocites: ', num2str(out.x.Data(end,1)), ...
            ', ', num2str(out.x.Data(end,2))])
    
    % Control info
    disp(['Control peak: ', num2str(max(out.u))]);
    disp(['Control steady: ', num2str(out.u.Data(end))]);
    
    disp(''), disp('');
end