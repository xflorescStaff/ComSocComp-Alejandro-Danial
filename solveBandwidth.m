function [rho_i, rho_H] = solveBandwidth(all_params, beth, bets)
    
    c_t     = all_params.c_t;
    c_Bu    = all_params.c_Bu;
    c_Bh    = all_params.c_Bh;

    di      = all_params.Ti_c(:,1);
    Bu      = all_params.Bu;
    Bh      = all_params.Bh;
    
    SNR_i   = all_params.SNR_i;
    SNR_hs  = all_params.SNR_hs;
    SNR_sg  = all_params.SNR_sg;

    rho_i = solve_rho_i(di, beth, Bu, SNR_i, c_t, c_Bu);

    rho_H = solve_rho_H(di, bets, Bh, SNR_hs, SNR_sg, c_t, c_Bh);



end