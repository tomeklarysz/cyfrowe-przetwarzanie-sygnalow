clear all; close all;

fpilot = 19e3;
fi = pi/3;
fs = 140e3;
T = 0.01;
t = 0:1/fs:T;
p = cos(2*pi*fpilot*t + fi);

% Petla PLL z filtrem typu IIR do odtworzenia częstotliwości i fazy pilota [7]
% i na tej podstawie sygnałów nośnych: symboli c1, stereo c38 i danych RDS c57
freq = 2*pi*fpilot/fs;
theta = zeros(1,length(p)+1);
alpha = 1e-2;
beta = alpha^2/4;
for n = 1 : length(p)
perr = -p(n)*sin(theta(n));
theta(n+1) = theta(n) + freq + alpha*perr;
freq = freq + beta*perr;
end
c57(:,1) = cos(3*theta(1:end-1)); % nosna 57 kHz

z = 1:100;
pll = cos(theta(1:end-1));

figure;
plot(t(z), p(z)); hold on;
plot(t(z), pll(z));
title('pierwsze 100 probek');
legend('sygnal p', 'syngal po PLL');

k = length(p)-100:length(p);
figure;
plot(t(k), p(k)); hold on;
plot(t(k), pll(k));
title('ostatnie 100 probek');
legend('sygnal p', 'syngal po PLL');

% jak szybko sygnal przechodzacy przez petle zbiega sie w fazie

% exp bo na samych cosinusach gorzej przez okresowosc
p_exp = exp(1j * (2*pi*fpilot*t + fi));
pll_exp = exp(1j * theta(1:end-1));
phase_diff = unwrap(angle(p_exp .* conj(pll_exp)));

figure;
plot(t,phase_diff);
legend('blad fazy'); pause;



% 2 punkt
df = 10;
fm = 0.1;
% t = 0:1/fs:0.;
ft = fpilot + df*sin(2*pi*fm*t);
p2 = cos(2*pi*cumsum(ft)/fs);

% Petla PLL z filtrem typu IIR do odtworzenia częstotliwości i fazy pilota [7]
% i na tej podstawie sygnałów nośnych: symboli c1, stereo c38 i danych RDS c57
freq = 2*pi*fpilot/fs;
theta = zeros(1,length(p2)+1);
alpha = 1e-2;
beta = alpha^2/4;
for n = 1 : length(p2)
perr = -p2(n)*sin(theta(n));
theta(n+1) = theta(n) + freq + alpha*perr;
freq = freq + beta*perr;
end

figure;
plot(t, p2); hold on;
plot(t, cos(theta(1:end-1)));
legend('sygnal p', 'syngal po PLL');

% jak szybko sygnal przechodzacy przez petle zbiega sie w fazie

% exp bo na samych cosinusach gorzej przez okresowosc
p_exp = exp(1j * (2*pi*fpilot*t + fi));
pll_exp = exp(1j * theta(1:end-1));
phase_diff = unwrap(angle(p_exp .* conj(pll_exp)));

figure;
plot(t,phase_diff);
legend('blad fazy');
