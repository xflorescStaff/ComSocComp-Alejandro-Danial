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



