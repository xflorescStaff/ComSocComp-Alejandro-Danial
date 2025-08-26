function rho_i = solve_rho_i(di, Bu, SNR_i, c_t, c_Bu)
    
    ai      = (c_t*di/Bu)*(1./log2(1+SNR_i));    % Delay cost per unit bandwidth
    bi      = c_Bu*Bu;                  % Bandwidth cost per unit bandwidth
    
    I = length(di);

    % Check if optimal values are jointly feasible

    rho_opt_i = sum(sqrt(ai./bi));

    if rho_opt_i>1
        rho_i = rho_opt_i;
    end

    % Bisection algorithm
    
    [~,amax] = max(ai./bi);
    nu_max = ai(amax)*(I^2) - bi(amax);
    nu_min = 0;

    % Check maximum feasibility
    while 1
        rho_max = sqrt(ai(amax)./( bi(amax) + nu_max ));

        if rho_max >1
            break;
        else
            nu_min = nu_max;
            nu_max = nu_max*2;
        end
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

end