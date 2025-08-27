%%

%%
clc, clear, close all

N = 64;

A = 5;
B = 1000;

% rng('default')

a = A*abs(rand(N,1));
b = B*abs(rand(N,1));

[~,amax] = max(a./b);

nu_max = a(amax)*(N^2) - b(amax);
nu_min = -min(b);
dnu= 0.01;

nu = nu_min:dnu:nu_max;

y = sqrt(a./(b+nu));

yf = sum(y,1);

plot(nu,yf)
hold on
yline(1)

%%
clc, clear, close all


all_params = initProblem();
di = all_params.Ti_c(:,1);
Bu = all_params.Bu;
Bh = all_params.Bh;

SNR_i   = all_params.SNR_i;
SNR_hs  = all_params.SNR_hs;
SNR_sg  = all_params.SNR_sg;

% SNR_i = all_params.Pi*all_params.Gih'/all_params.Pnh;
% 
% SNR_hs = all_params.Ph*all_params.Ghs/all_params.Pns;
% 
% SNR_sg = all_params.Ps*all_params.Gsg/all_params.Png;

c_t = 10000;
c_Bu = 0.001;
c_Bh = 0.005;
It = all_params.It;


beth = randomOnes(It, 0.5);
bets = max(randomOnes(It,0.25), beth);

figure
hold on
plot(beth)
plot(bets)


% rho_i = solve_rho_i(di, beth, Bu, SNR_i, c_t, c_Bu);
% 
% rho_B = solve_rho_H(di, bets, Bh, SNR_hs, SNR_sg, c_t, c_Bh)

[rho_i, rho_H] = solveBandwidth(all_params, beth, bets, c_t, c_Bu, c_Bh)


%%
clc, clear, close all

all_params = initProblem();
di = all_params.Ti_c(:,1);
Bu = all_params.Bu;
SNR_i = all_params.Pi*all_params.Giu'/all_params.Pnu;
c_t = 10000;
c_Bu = 0.001;

    ai      = (c_t*di/Bu).*(1./log2(1+SNR_i));    % Delay cost per unit bandwidth
    bi      = c_Bu*Bu;                  % Bandwidth cost per unit bandwidth
    
    I = length(di);

    % Check if optimal values are jointly feasible

    rho_opt_i = sum(sqrt(ai./bi));

    if rho_opt_i<=1
        rho_i = rho_opt_i;
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
        % fprintf('Loop2\n')
    end
