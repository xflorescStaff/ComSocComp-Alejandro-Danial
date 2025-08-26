function Huh = get_H_UH_AP(ru, rh, lua, Auh)
    
    duh     = norm(ru-rh);
    Huh     = (lua/(4*pi*duh))*Auh;
    
end
