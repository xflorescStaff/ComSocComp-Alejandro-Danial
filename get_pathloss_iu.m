function L = get_pathloss_iu(ru, ri, fiu)
    phi         = 4.88;         % Environmental constant
    omega       = 0.429 ;        % Environmental constant
    alpha_AG    = 2;            % Air-to-Ground Path Loss Exponent
    % params from "Optimal LAP Altitude for Maximum Coverage" (urban)
    ne_LOS      = 0.1;            % Air-to-Ground LOS attenuation
    % ne_NLOS     = 2;           % Air-to-Ground NLOS attenuation
    ne_NLOS     = 21;           % Air-to-Ground NLOS attenuation
    
    rj          = ri - ru;
    dj          = sqrt(sum(rj.^2,1));
    % thetaj      = 90 - acos(-rj(3,:)./dj)*180/pi;
    thetaj      = asin(-rj(3,:)./dj)*180/pi;
    PLoS        = 1./(1 + phi * exp( -omega*( thetaj - phi ) ) );
    
    L_dB = 10*alpha_AG*log10( 4*pi*dj*fiu / (3e8) ) + PLoS*ne_LOS + (1-PLoS)*ne_NLOS;
    L = db2pow(L_dB);
    
end