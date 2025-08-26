function A = get_as_UPA(ru, ri, M)
    % Function that computes beamsteerers from IoT devices to UAV
    sM = sqrt(M);
    A = zeros(M, size(ri,2), size(ru,2));
    for k=1:size(ru,2)
        r_k = ru(:,k);
        
        rj      = ri - r_k;
        dj      = sqrt(sum(rj.^2,1));
        
        % Azimuth computation
        sig_i = sign(rj(1,:));
        sig_i(sig_i==0)=1;
        phij = sig_i .* acos( rj(2,:)./sqrt( rj(1,:).^2 + rj(2,:).^2 )    );
        phij(isnan(phij)) = 0;
        
        % Elevation computation
        thetaj  = acos(-rj(3,:)./dj);
        
        % Beamsteering vectors --------------------------------------------
        BFexpX = exp(-1j*pi*(0:sM-1)'.*( sin(thetaj).*sin(phij) ));
        BFexpY = exp(-1j*pi*(0:sM-1)'.*( sin(thetaj).*cos(phij) ));

        BFexpX_t = reshape(BFexpX, [size(BFexpX,1), 1, size(BFexpX,2)]);
        BFexpY_t = reshape(BFexpY, [1, size(BFexpY,1), size(BFexpY,2)]);

        BFexpPh = BFexpX_t.*BFexpY_t;

        A(:,:,k) = reshape(BFexpPh, [size(BFexpPh,1)*size(BFexpPh,2), size(BFexpPh,3)]);
    end
    A = A/sqrt(M);
end
