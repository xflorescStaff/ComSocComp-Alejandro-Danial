%%
%%
clc, clear, close all
all_params = initProblem();

p = 1;
c_t = 10000;
c_Bu = 0.001;
c_Bh = 0.005;

[beth, bets] = initBeta(p, all_params.It);
[rho_i, rho_H] = solveBandwidth(all_params, beth, bets, c_t, c_Bu, c_Bh);

