function rho_i = solve_rho_i(di, beth, Bu, SNR_i, c_t, c_Bu)
    
    dh      = di(beth==1);
    SNR_h   = SNR_i(beth==1);

    ai      = (c_t*dh/Bu).*(1./log2(1+SNR_h));    % Delay cost per unit bandwidth
    bi      = c_Bu*Bu;                  % Bandwidth cost per unit bandwidth
    
    I = length(dh);

    % Check if optimal values are jointly feasible

    rho_opt_i = sum(sqrt(ai./bi));

    if rho_opt_i<=1
        rho_i = sqrt(ai./bi);
        return;
    end

    % Bisection algorithm
    
    [~,amax] = max(ai./bi);
    nu_max = ai(amax)*(I^2) - bi;
    nu_min = 0;

    % Check maximum feasibility
    while 1
        if bi + nu_max <=0
            nu_min = -bi;
            nu_max = 0;
        end
        rho_max = sqrt(ai(amax)./( bi + nu_max ));

        if rho_max <1
            break;
        else
            nu_min = nu_max;
            nu_max = nu_max*2;
        end
        fprintf('Loop1\t rho_max = %f \t nu_max = %f\n', rho_max, nu_max)
        % pause
    end

    % Start bisection loop
    Nn = 30;
    for nn=1:Nn
        nu = (nu_min + nu_max)/2;
        rho_bis_i = sum(sqrt(ai./(bi + nu)));
        if rho_bis_i < 1
            nu_max = nu;
        else
            nu_min = nu;
        end
    end
    rho_i = zeros(size(di));
    rho_i(beth==1) = sqrt(ai./(bi + nu));

end