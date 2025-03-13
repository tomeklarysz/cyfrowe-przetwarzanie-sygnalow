clear all; close all;
f = 50;
T = 0.1;

fs = 200;
dt = 1/fs;
t = 0:dt:T;
x = sin(2*pi*f*t);

ts = 0:(1/10e3):T;
analog = sin(2*pi*f*ts);

x_odt = zeros(size(ts));
for i = 1:length(t)
    x_odt = x_odt + x(i) * sinc((ts - t(i))/ dt);
end

errors = analog - x_odt;

plot(ts,analog,'k--'); hold on;
plot(ts,x_odt,'b'); hold on;
plot(ts,errors,'-');
legend('Oryginalny sygnał', 'Zrekonstruowany sygnał', 'Błąd rekonstrukcji');
title('Rekonstrukcja sygnału z użyciem sin(x)/x')