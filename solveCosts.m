function [cmec, cmcc, beth, bets] = solveCosts(all_params, rho_i, rho_H, fhi)

    c_t     = all_params.c_t;
    c_Bu    = all_params.c_Bu;
    c_Bh    = all_params.c_Bh;

    di      = all_params.Ti_c(:,1);
    ci      = all_params.Ti_c(:,2);
    Bu      = all_params.Bu;
    Bh      = all_params.Bh;
    
    SNR_i   = all_params.SNR_i;
    SNR_hs  = all_params.SNR_hs;
    SNR_sg  = all_params.SNR_sg;

    Fi      = all_params.Fi;

    tp_hs   = all_params.tus_v;
    tp_sg   = all_params.tsg_v;


    Ri      = rho_i*Bu.*log2( 1 + SNR_i  );
    Rhs     = rho_H*Bh*log2( 1 + SNR_hs );
    Rsg     = rho_H*Bh*log2( 1 + SNR_sg );

    

    % Delay calculations
    % dl = di(beth==0);                   % di for IoT local tasks
    % cl = ci(beth==0);                   % ci for IoT local tasks
    % 
    % dh = di(beth==1);                   % di for IoT-HAPS offloads 
    % Rh = Ri(beth==1);                   % Ri for IoT-HAPS offloads 
    % 
    % dhl = di((beth==1) & (bets==0));       % di for tasks computed att HAPS
    % chl = ci((beth==1) & (bets==0));       % ci for tasks computed att HAPS
    % 
    % ds = di(bets==1);                   % di for HAPS-LEO-GW offloads

    % 
    % fmec = fhi;

    t_ii = di.*ci/Fi;                   % Delay for local computations
    t_ih = di.*ci./fhi;               % Delay for HAPS computations
    
    tih = di./Ri;                       % Delay for IoT-HAPS offloads
    

    % MEC
    % Get the minimum costs to be charged for offloading to occur
    cmec = c_t*t_ii - ( c_t*tih + c_Bu*rho_i*Bu );      % Minimum costs per task at MEC
    cmec(cmec<0) = 0; % If the tasks are negative, no cost can make them offload

    % Get the beta variables as the ones with possitive minimum cost
    beth = cmec>0;
    
    % MCC
    ths = (sum(di(beth))/Rhs) + 2*tp_hs;      % Delay for HAPS-LEO offloads
    tsg = (sum(di(beth))/Rsg) + 2*tp_sg;      % Delay for LEO-GW offloads

    cmcc_t = c_t*( t_ih(beth) - (ths + tsg) );        % Minimum costs per task at MCC (upperbound)

    cmcc_t(cmcc_t<0) = 0;
    
    cmcc = zeros(size(cmec));
    cmcc(beth) = cmcc_t;

    bets = cmcc>0;

    

    
end