clear all; close all;
T = 1;
fs = 10e3;
fn = 50;
fm = 1;
df = 5;

% FM: A*sin(fn*t + k*calka(x(t)dt))
t = 0:1/fs:T;
modulujacy = sin(2*pi*fm*t);
zmodulowany = sin(2*pi*fn*t + 2*pi*df*modulujacy);

figure;
plot(t,modulujacy,'b'); hold on;
plot(t,zmodulowany,'r'); grid on;
title('Sygnał zmodulowany i modulujący');
legend('Sygnał modulujący', 'Sygnał zmodulowany');
hold off;

fsp = 25;
tp = 0:1/fsp:T;
sprobkowany = sin(2*pi*fn*tp + 2*pi*df*sin(2*pi*fm*tp));
error = zmodulowany(1:length(tp)) - sprobkowany;
grid on;
figure;
plot(t,zmodulowany,'b'); hold on;
plot(tp,sprobkowany,'k-o',LineWidth=1.5); hold off;
title('Spróbkowanie sygnału zmodulowanego');
legend('Sygnał "analogowy"','Sygnał spróbkowany');
figure;
stem(tp,error,'r',LineWidth=1.4);
title('Błędy próbkowania');

% widma gęstości mocy
Hs = spectrum.periodogram;
figure;
plot(psd(Hs,zmodulowany,'Fs',fs));
title('Widmo gęstości mocy przed spróbkowaniem');

figure;
plot(psd(Hs,sprobkowany,'Fs',fsp));
title('Widmo gęstości mocy po spróbkowaniu');