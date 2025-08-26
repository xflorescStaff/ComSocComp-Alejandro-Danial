function Auh = get_as_UH(ru, rh, Mul, Mh)
    % Function that computes rank-1 array response from UAV to HAPS (assume ULAs)
    rj      = rh - ru;
    dj      = sqrt(sum(rj.^2,1));
    thetau  = acos(rj(3,:)./dj);                       % Elevation computation
    au      = exp(-1j*pi*(0:Mul-1)'.*( sin(thetau) ));  % UAV array response vector
    % au      = au/norm(au);
    
    rj      = ru - rh;
    dj      = sqrt(sum(rj.^2,1));
    thetah  = acos(-rj(3,:)./dj);                       % Elevation computation
    ah      = exp(-1j*pi*(0:Mh-1)'.*( sin(thetah) ));   % UAV array response vector
    % ah      = ah/norm(ah);
    
    Auh = ah*au';
    
end
