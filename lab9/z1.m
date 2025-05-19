clear;
close all;

A1 = -0.5; f1 = 34.2;
A2 = 1;    f2 = 115.5;
fs = 8e3;
T = 1;
dt = 1/fs;
% t = 0:dt:T;
N = fs*T;
t = (0:N-1)/fs;

dref1 = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t); % sygnał ”czysty” do porównania

% SFM
fc = 1e3;
deltaf = 0.5e3;
fm = 0.25;
dref2 = sin(2*pi*fc*t + deltaf/fm + sin(2*pi*fm*t));


powers = [10, 20, 40];
drefs = {dref1, dref2};
for i=1:length(drefs)
dref = drefs{i};
for p=1:length(powers)
d = awgn( dref, powers(p), 'measured' ); % sygnal + szum

x = [ d(1) d(1:end-1) ]; % WE: sygnał filtrowany, teraz opóźniony d
M = 30; % długość filtru
mi = 0.01; % współczynnik szybkości adaptacji
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
snr = 10*log10(sum(dref.^2)/sum((dref - y ).^2)),

figure;
sgtitle(powers(p));
% plot(t,dref,t,x,t,y);
subplot(311);
plot(t,dref);
title('sygnal oryginalny');
% ylim([-2.5 2.5]);
% figure;
subplot(312);
plot(t,d);
title('sygnal zaszumiony');
% ylim([-2.5 2.5]);
% figure;
subplot(313);
plot(t,y);
title('sygnal odszumiony');
% ylim([-2.5 2.5]);

% legend('sygnał oryginalny', 'sygnał zaszumiony', 'sygnał odszumiony');
end
end