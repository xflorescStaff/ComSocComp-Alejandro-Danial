function all_params = initProblem(varargin)

    B       = 1;       % Number of available channels      % A 20 MHz LTE channel for 1.4 MHz LTE-M IoT channels
    Mul     = 16;        % Number of antenna elements in HAPS downward UPA
    Mh      = 256;       % Number of antenna elements in HAPS upward UPA
    Ms      = 484;      % Number of antenna elements in LEO
    Mg      = 484;      % Number of antenna elements in GW


    if nargin>=1;  It   = varargin{1};        else; It  = 14;       end            % Number of IoT nodes
    if nargin>=2;  Fi   = varargin{2}{1};     else; Fi = 64e6;       end            % Comp. resources IoT
    if nargin>=2;  Fhu  = varargin{2}{2};     else; Fhu = 10e9;      end            % Comp. resources HAPS
    if nargin>=3;  mTask_o = varargin{3}{1} ; else ; mTask_o = 10e3; end            % Lower,  payload size
    if nargin>=3;  mTask_f = varargin{3}{2} ; else ; mTask_f = 100e3;end            % Higher, payload size
    if nargin>=4;  cTask_o = varargin{4}{1} ; else ; cTask_o = 5;    end            % Lower,  comp. density
    if nargin>=4;  cTask_f = varargin{4}{2} ; else ; cTask_f = 25;   end            % Higher, comp. density
    if nargin>=5;  tTask_o = varargin{5}{1} ; else ; tTask_o = 1;    end            % Lower,  max delay
    if nargin>=5;  tTask_f = varargin{5}{2} ; else ; tTask_f = 1;    end            % Higher, max delay
    if nargin>=6;  d_iu    = varargin{6} ;    else ; d_iu = 200;     end            % Average distance from IoT nodes to UAV
    
    % Carrier frequencies
    fiu     = 2.1e9;
    fua     = 28e9;
    
    % Carrier wavelengths
    liu     = 3e8/fiu;
    lua     = 3e8/fua;
    Dua     = lua;
    
    % Bandwidths
    Bu = 1.4e6;     % Bandwidth per Iot-HAPS subchannel [Hz]
    Bh = 100e6;     % Bandwidth per HAPS-LEO-GW  subchannel [Hz]
    
    
    Pi      = 0.5;          % Total power available at IoT device in watts [W] (200 mW minimum according to TR 38.811)
    Pu      = 2;            % Total power available at UAV [W]
    Ps      = 1;            % Total power available at LEO [W]
    
    % Positions of nodes

    % ru = [0,    0,    200  ]' ;    % Position of HAPS
    rh = [0,    0,    20e3 ]' ;    % Position of HAPS
    rs = [0,    5e3,  500e3]';   	% Position of LEO
    rg = [0,    10e3,     0]';   	% Position of GW

    
    tus_v = sqrt(sum((rs - rh).^2))/(3e8);        % One way UAV-LEO delay
    tsg_v = sqrt(sum((rg - rs).^2))/(3e8);        % One way LEO-GW delay

    % Noise
    N0          = -174;                             % Noise dBm per Hz
    Pnu_dBm      = pow2db(db2pow(N0)*Bu);           % IoT-HAPS noise power in dBm
    Pnu          = db2pow(Pnu_dBm)*(1e-3);          % IoT-HAPS noise power in W
    Pnh_dBm      = pow2db(db2pow(N0)*Bh);           % HAPS-LEO noise power in dBm
    Pnh          = db2pow(Pnh_dBm)*(1e-3);          % HAPS-LEO noise power in W
    Png_dBm      = Pnh_dBm;                         % LEO-GW noise power in dBm
    Png          = Pnh;                             % LEO-GW noise power in W
    
    
    Pn_dB       = -109 - 30;        % Noise power in dBW
    Pn          = db2pow(Pn_dB);    % Noise power [W]

    
    
    % gs_ap = getAntPat_Horn(Dua, lua, rs, ru);
    % gh_ap = getAntPat_Cos(2, rh, ru);
        
        ri_c        = ( d_iu )*randn(3,It) + rh;
        ri_c(3,:)   = 0;
        
        % Computing IoT-HAPS Rice channels
        A_c = get_as_UPA(rh, ri_c, Mul);
        Hiu_c = get_hiu(rh, ri_c, A_c, fiu, B);
        Giu   = sum(conj(Hiu_c).*Hiu_c,1);      % Channel Gains
    
        % Compute HAPS-LEO LoS MIMO channels
        Ahs_c = get_as_UH(rh, rs, Mh, Ms);
        Hhs_c = get_H_UH_AP( rh, rs, lua, Ahs_c);
        Ghs = (max(svd(Hhs_c))^2);              % Channel Gains

        % Compute LEO-GW channels
        Asg_c = get_as_UH(rs, rg, Ms, Mg);
        Hsg_c = get_H_UH_AP( rs, rg, lua, Asg_c);
        Gsg = (max(svd(Hsg_c))^2);              % Channel Gains

        sys_params_c = struct( ...
                'I',    It, ...
                'B',    B, ...
                'Bu',   Bu, ...
                'Bh',   Bh, ...
                'Mul',  Mul, ...
                'Mh',   Mh, ...
                'Ms',   Ms, ...
                'Mg',   Mg, ...
                'Fi',   Fi, ...
                'Fhu',   Fhu, ...
                'Pi',   Pi, ...
                'Pu',   Pu, ...
                'Ps',   Ps, ...
                'Pnu',  Pnu,...
                'Pnh',  Pnh,...
                'Png',  Png,...
                'fiu',  fiu, ...
                'fua',  fua, ...
                'liu',  liu, ...
                'lua',  lua);

        % Task generation
            % Task size (bits)
        di = (mTask_f - mTask_o)*rand(1,It) + mTask_o;

            % Cycles/bit
        ci = (cTask_f - cTask_o)*rand(1,It) + cTask_o;
    
            % Maximum delay
        ti = (tTask_f - tTask_o)*rand(1,It) + tTask_o;
        
        Ti_c = [di; ci; ti]';      % Tasks in total
  
    
    
    
    
    sys_res_all = struct(...
                'Fi',   Fi, ...
                'Fhu',  Fhu, ...
                'Pi',   Pi, ...
                'Pu',   Pu, ...
                'Ps',   Ps, ...
                'Pnu',  Pnu,...
                'Pnh',  Pnh,...
                'Png',  Png,...
                'Bu',   Bu,...
                'B',    B);
    

    
    % Get all variable names in the current workspace
    vars = who;
    
    % Initialize an empty struct
    all_params = struct();
    
    % Loop over each variable and add it to the struct
    for i = 1:length(vars)
        var_name = vars{i};
        all_params.(var_name) = eval(var_name);  % Use eval to get the value of the variable
    end

end