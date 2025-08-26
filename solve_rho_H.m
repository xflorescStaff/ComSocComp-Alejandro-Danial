function rho_B = solve_rho_H(di, bets, Bh, SNR_hs, SNR_sg, c_t, c_Bh)
    
    di_g        = di(bets==1);
        
    Imcc    = size(di_g,1);           % Number of tasks offloaded from HAPS to GW through LEO
    ah      = (c_t*Imcc/Bh)*(1./log2(1+SNR_hs) + 1./log2(1+SNR_sg))*sum(di_g);    % Delay cost per unit bandwidth
    bh      = c_Bh*Bh;                  % Bandwidth cost per unit bandwidth
    rho_B   = min(1, sqrt(ah./bh));     % Resulting share of total bandwidth
end