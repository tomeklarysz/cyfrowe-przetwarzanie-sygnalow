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

[dref3, f_3] = audioread("engine.wav");
dref3 = dref3(1:fs);
dref3 = dref3';

powers = [10, 20, 40];
drefs = {dref1, dref2, dref3};
for i=1:length(drefs)
dref = drefs{i};
fprintf('%d.\n',i);
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
snr = 10*log10(sum(dref.^2)/sum((dref - y ).^2));
fprintf('snr dla %d dB = %.4f dB\n', powers(p), snr);

z = 1:500;

figure;
sgtitle(powers(p));
% plot(t,dref,t,x,t,y);
subplot(311);
plot(t(z),dref(z));
title('sygnal oryginalny');
% ylim([-2.5 2.5]);
% figure;
subplot(312);
plot(t(z),d(z));
title('sygnal zaszumiony');
% ylim([-2.5 2.5]);
% figure;
subplot(313);
plot(t(z),y(z));
title('sygnal odszumiony');
% ylim([-2.5 2.5]);
end
pause;
end

% porownanie liczb wag filtra
d = awgn( dref1, 20, 'measured' ); % sygnal + szum
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

figure;
plot(t(z),dref(z));
title('sygnal oryginalny');

Ms = [15,30,60,120,240,480];
Ms_signals = zeros(1,length(Ms));

for p=1:length(Ms)
d = awgn( dref, 20, 'measured' ); % sygnal + szum

x = [ d(1) d(1:end-1) ]; % WE: sygnał filtrowany, teraz opóźniony d
M = Ms(p); % długość filtru
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
Ms_signals(p) = y;

end

figure;
for s=1:Ms_signals
    z = 1:500;
    plot(t,Ms_signals(s)); hold on;
    title('sygnal odszumiony');
end