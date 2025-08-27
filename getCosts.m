function [C_loc, C_mec, C_mcc] = getCosts(all_params, beth, bets, rho_i, rho_H, fhi, cost_mec, cost_mcc)
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
    dl = di(beth==0);                   % di for IoT local tasks
    cl = ci(beth==0);                   % ci for IoT local tasks

    dh = di(beth==1);                   % di for IoT-HAPS offloads 
    Rh = Ri(beth==1);                   % Ri for IoT-HAPS offloads 

    dhl = di((beth==1) & (bets==0));       % di for tasks computed att HAPS
    chl = ci((beth==1) & (bets==0));       % ci for tasks computed att HAPS

    ds = di(bets==1);                   % di for HAPS-LEO-GW offloads


    fmec = fhi((beth==1) & (bets==0));

    t_ii = dl.*cl/Fi;                   % Delay for local computations
    t_ih = dhl.*chl./fmec;               % Delay for HAPS computations
    
    tih = dh./Rh;                       % Delay for IoT-HAPS offloads
    ths = (sum(ds)/Rhs) + 2*tp_hs;      % Delay for HAPS-LEO offloads
    tsg = (sum(ds)/Rsg) + 2*tp_sg;      % Delay for LEO-GW offloads

    cmec = cost_mec(beth==1);
    cmcc = cost_mcc(bets==1);

    % Local cost

    % Cl = (c_t*t_ii) + c_t*tih ...
    %      +      c_Bu*rho_i*Bu  + cmec;

    Cl_loc = c_t*t_ii;
    Cl_off =    c_Bu*rho_i*Bu  + cmec + c_t*tih;

    Ch = - sum( c_Bu*rho_i*Bu  + cmec)    ...
         + sum(c_t*t_ih) + c_t*(ths + tsg)*sum(bets) ...
         + c_Bh*rho_H*Bh + sum(cmcc);

    Cg = - c_Bh*rho_H*Bh - sum(cmcc);

    C_loc = zeros(size(di));

    C_loc(beth==0) = Cl_loc;
    C_loc(beth==1) = Cl_off;
    C_mec = Ch;
    C_mcc = Cg;

    

end