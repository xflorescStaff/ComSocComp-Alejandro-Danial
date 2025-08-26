%%

%%
clc, clear, close all

N = 64;

A = 5;
B = 1000;

% rng('default')

a = A*abs(rand(N,1));
b = B*abs(rand(N,1));

[~,amax] = max(a./b);

nu_max = a(amax)*(N^2) - b(amax);
nu_min = -min(b);
dnu= 0.01;

nu = nu_min:dnu:nu_max;

y = sqrt(a./(b+nu));

yf = sum(y,1);

plot(nu,yf)
hold on
yline(1)

