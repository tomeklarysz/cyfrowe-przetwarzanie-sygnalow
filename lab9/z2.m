clear all; close all;

[Sa, f_sa] = audioread("mowa_1.wav");
[x, f_sb] = audioread("mowa_2.wav");
[d, f_d] = audioread("mowa_3.wav");

% soundsc(d, f_d);

M = 20; % długość filtru
mi = 0.1; % współczynnik szybkości adaptacji
y = []; e = []; % sygnały wyjściowe z filtra
bx = zeros(M,1); % bufor na próbki wejściowe x
h = zeros(M,1); % początkowe (puste) wagi filtru
for n = 1 : length(x)
bx = [ x(n); bx(1:M-1) ]; % pobierz nową próbkę x[n] do bufora
y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) – filtr FIR
e(n) = d(n) - y(n); % oblicz e[n]
h = h + mi * e(n) * bx; % LMS
% h = h + mi * e(n) * bx /(bx'*bx); % NLMS
end

% soundsc(Sa, f_sa);
% soundsc(e,f_sa);

t = 0:length(Sa)-1/f_sa;
z = 1:10000;

figure;
subplot(211);
plot(t(z),Sa(z));
title('glos A');
subplot(212);
plot(t(z),e(z));
title('estymowany sygnal e');

% snr = 10*log10(sum(Sa.^2)/sum(Sa-e').^2);
% fprintf('snr = %.4f\n',snr);