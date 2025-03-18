clear all; close all;
N = 20;
k = (0:N-1); n=(0:N-1); 
S = sqrt(2/N) * cos((pi/N) * (n'+1/2)*k);

A = S';
% A*S, pause;

x = randn(N,1);
c = A*x;  % analiza
xs = S*c; % synteza (rekonstrukcja)

error = max(abs(x-xs)),