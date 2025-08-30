%%
% {It, {Fi  , Fhu }, {mTask_o, mTask_f}, {cTask_o, cTask_f}, {tTask_o, tTask_f}, d_iu, {c_t,   c_Bu,  c_Bh},  p }
% {14, {64e6, 10e9}, {10e3,    100e3  }, {5,       25     }, {1,       1      }, 200,  {10000, 0.001, 0.005}, 1 }
% 
%%
clc, clear, close all
       % {It, {Fi  , Fhu }, {mTask_o, mTask_f}, {cTask_o, cTask_f}, {tTask_o, tTask_f}, d_iu, {c_t,   c_Bu,  c_Bh},  p }
params = {14, {64e6, 10e9}, {10e3,    100e3  }, {5,       25     }, {1,       1      }, 200,  {10e7, 0.1, 0.005}, 1 };
params = {14, {64e6, 10e9}, {10e3,    100e3  }, {100,     500    }, {1,       1      }, 200,  {10e7, 0.1, 0.005}, 1 };
all_params = initProblem(params{:});        % Initialize parameters

fhi = initfh(all_params); 
[beth, bets] = initBeta(all_params);

% Initialize rho variables (bandwidths fully occupied)
[rho_i, ~] = solveBandwidth(all_params, beth, bets);
rho_i   = rho_i/(sum(rho_i));
rho_H   = 1;

% Solution
[cmec, cmcc, beth, bets] = solveCosts(all_params, rho_i, rho_H, fhi);   % Get costs
[rho_i, rho_H] = solveBandwidth(all_params, beth, bets);                % Get optimal bandwidths
fhi = solveFh(all_params, beth, bets);                                  % Get optimal resources


[C_loc, C_mec, C_mcc] = getCosts(all_params, beth, bets, rho_i, rho_H, fhi, cmec, cmcc); % Get costs

% % %%
% % % [cost_mec, cost_mcc] = solveCosts()
% % % [beth, bets] = solveOffloading()
% % cost_mec = ones(all_params.It,1);
% % cost_mcc = ones(all_params.It,1);
% % 
% % 
% % 
% % [C_loc, C_mec, C_mcc] = getCosts(all_params, beth, bets, rho_i, rho_H, fhi, cost_mec, cost_mcc);
% % 
% % 
% % 
% % 
% % 
% % Ri  = rho_i.*all_params.Bu.*log2(1 + all_params.SNR_i)
% % 
% % Rhs = rho_H.*all_params.Bh.*log2(1 + all_params.SNR_hs)
% % 
% % Rsg = rho_H.*all_params.Bh.*log2(1 + all_params.SNR_sg)
% % 

%% Get by c_t and c_Bu=c_Bh
clc, clear, close all


ct_vec_dB = 30:0.5:70;
ct_vec = 10.^(ct_vec_dB/10);

cB_vec_dB = -40:0.5:0;
cB_vec = 10.^(cB_vec_dB/10);

x_vec = ct_vec;
y_vec = cB_vec;

Nx = size(x_vec,2);
Ny = size(y_vec,2);

It = 14;                % Number of GDs

rho_i_vec = zeros(It,Nx,Ny);
rho_H_vec = zeros(   Nx,Ny);
beth_vec  = zeros(It,Nx,Ny);
bets_vec  = zeros(It,Nx,Ny);
fhi_vec   = zeros(It,Nx,Ny);
cmec_vec  = zeros(It,Nx,Ny);
cmcc_vec  = zeros(It,Nx,Ny);

C_loc_vec = zeros(It,Nx,Ny);
C_mec_vec = zeros(   Nx,Ny);
C_mcc_vec = zeros(   Nx,Ny);

iMC = 1;

for ix = 1:Nx
    for iy = 1:Ny
        fprintf('ix = %d \t iy = %d \n', ix, iy);
        c_t     = x_vec(ix);
        c_Bu    = y_vec(iy);
        c_Bh    = y_vec(iy);

        params          = {It, {64e6, 10e9}, {10e3, 1000e3}, {100, 500}, {1,1}, 200,  {c_t,   c_Bu,  c_Bh}, 1, iMC };
        all_params      = initProblem(params{:});        % Initialize parameters
        
        fhi             = initfh(all_params); 
        [beth, bets]    = initBeta(all_params);
        
        % Initialize rho variables (bandwidths fully occupied)
        [rho_i, ~]      = solveBandwidth(all_params, beth, bets);
        rho_i           = rho_i/(sum(rho_i));
        rho_H           = 1;
        
        % Solution
        [cmec, cmcc, beth, bets]    = solveCosts(all_params, rho_i, rho_H, fhi);   % Get costs
        [rho_i, rho_H]              = solveBandwidth(all_params, beth, bets);                % Get optimal bandwidths
        fhi                         = solveFh(all_params, beth, bets);                                  % Get optimal resources
        
        
        [C_loc, C_mec, C_mcc] = getCosts(all_params, beth, bets, rho_i, rho_H, fhi, cmec, cmcc); % Get costs
        
        rho_ij = zeros(size(C_loc));
        rho_ij(beth) = rho_i;

        rho_i_vec(:,ix,iy) = rho_ij;
        rho_H_vec(ix,iy) = rho_H;
        beth_vec(:,ix,iy)  = beth;
        bets_vec(:,ix,iy)  = bets;
        fhi_vec(:,ix,iy)   = fhi;
        cmec_vec(:,ix,iy)  = cmec;
        cmcc_vec(:,ix,iy)  = cmcc;
        
        C_loc_vec(:,ix,iy) = C_loc;
        C_mec_vec(ix,iy) = C_mec;
        C_mcc_vec(ix,iy) = C_mcc;
    end
end
save('data_ct_cb.mat')
%%
close all

fig1 = figure('Position',[0 0 490 350]);
[X,Y] = meshgrid(ct_vec, cB_vec);
surf(X,Y,-C_mec_vec', 'EdgeColor', 'none')
xlabel('$c_\tau$', 'Interpreter','Latex', 'FontSize',18)
ylabel('$c_B$', 'Interpreter','Latex', 'FontSize',18)
zlabel('$C_{\mathrm{MEC}}$', 'Interpreter','Latex', 'FontSize',18)

set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
% set(gca, 'ZScale', 'log')


fig2 = figure('Position',[0 0 490 350]);
[X,Y] = meshgrid(ct_vec, cB_vec);
surf(X,Y,-C_mec_vec', 'EdgeColor', 'none')
xlabel('$c_\tau$', 'Interpreter','Latex', 'FontSize',18)
ylabel('$c_B$', 'Interpreter','Latex', 'FontSize',18)
zlabel('$C_{\mathrm{MEC}}$', 'Interpreter','Latex', 'FontSize',18)

set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
set(gca, 'ZScale', 'log')



fig3 = figure('Position',[0 0 490 350]);
[X,Y] = meshgrid(ct_vec, cB_vec);
surf(X,Y,-C_mec_vec', 'EdgeColor', 'none')
view(2)
xlabel('$c_\tau$', 'Interpreter','Latex', 'FontSize',18)
ylabel('$c_B$', 'Interpreter','Latex', 'FontSize',18)
zlabel('$C_{\mathrm{MEC}}$', 'Interpreter','Latex', 'FontSize',18)

set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
set(gca, 'ZScale', 'log')


    % saveas(fig3, ['./times.png'])
    % exportgraphics(gcf,['./times.pdf'],'ContentType','vector')


%% Varying Fh and ci


