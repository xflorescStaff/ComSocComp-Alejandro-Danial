%%
% {It, {Fi  , Fhu }, {mTask_o, mTask_f}, {cTask_o, cTask_f}, {tTask_o, tTask_f}, d_iu, {c_t,   c_Bu,  c_Bh},  p }
% {14, {64e6, 10e9}, {10e3,    100e3  }, {5,       25     }, {1,       1      }, 200,  {10000, 0.001, 0.005}, 1 }
% 
%%
clc, clear, close all
       % {It, {Fi  , Fhu }, {mTask_o, mTask_f}, {cTask_o, cTask_f}, {tTask_o, tTask_f}, d_iu, {c_t,   c_Bu,  c_Bh},  p }
params = {14, {64e6, 10e9}, {10e3,    100e3  }, {5,       25     }, {1,       1      }, 200,  {10, 0.1, 0.005}, 1 };
all_params = initProblem(params{:});

fhi = initfh(all_params);
[beth, bets] = initBeta(all_params);
[rho_i, rho_H] = solveBandwidth(all_params, beth, bets);

% cost_mec = solveCosts()
cost_mec = ones(all_params.It,1);
cost_mcc = ones(all_params.It,1);



[C_loc, C_mec, C_mcc] = getCosts(all_params, beth, bets, rho_i, rho_H, fhi, cost_mec, cost_mcc);

