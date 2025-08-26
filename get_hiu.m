function hiu = get_hiu(ru, ri, A, fiu, B)
% hiu -> (Mul X I X B) -> (UAV antennas X IoT Users X subchannels)
%Hiu_c{ic}=    get_hiu(ru_v(:,ic), ri_c{ic}, A_c{ic}, fiu, B);
    % Rice channel modelling, specific for elevations
    a1      = 5;
    a2      = (2/pi)*log(3);
    
    % K factor computation
    rj      = ri - ru;
    dj      = sqrt(sum(rj.^2,1));
    thetaj  = acos(-rj(3,:)./dj);
    K       = db2pow( a1 * exp( a2*thetaj ) );

    % Rice channel computation (per subchannel)
    R       = (1/sqrt(2))*( randn([size(A), B]) + 1j*randn([size(A), B]) );
    alp     = sqrt(K ./ ( 1 + K ) );
    bet     = sqrt(1 ./ ( 1 + K ) );
    H_b     = alp.*A + bet.*R;

    % Include A2G pathloss in channel
    L       = get_pathloss_iu(ru, ri, fiu);
    hiu     = H_b./sqrt(L);

end