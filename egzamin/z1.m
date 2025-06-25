% zadanie 2.6
clear all; close all;

fpr = 8000;
Nx = 10*fpr;
% sygnal bedzie trwac 5 sekund
dt = 1/fpr;
n = 0:Nx-1;
t = dt*n;
A = 1;

fa = 2;     % czestotliwosc sygnalu modulujacego AM
            % czyli amplituda bedzie zmieniana z ta czestotliwoscia
kA = 0.3;   % glebokosc modulacji
mA = sin(2*pi*fa*t);

fc = 750;   % czestotliwosc nosna
fm = 0.2;     % czestotliwosc sygnalu modulujacego FM
            % (czyli częstotliwość nośna będzie zmieniania z tą częstotliwością - np. 2Hz = 2 razy na sekundę)
kF = 200;    % głębokość modulacji częstotliwości: mówi jak bardzo zmieni się częstotliwość chwilowa

mF = sin(2*pi*fm*t);

x = A*(1+kA*mA) .* sin(2*pi*(fc*t+kF*cumsum(mF)*dt));
soundsc(x,fpr);

% czemu cumsum?
% Numeryczne całkowanie sygnału dyskretnego m[n] (czyli m(t) próbkowanego) 
% można zrealizować za pomocą sumy kumulacyjnej.
% numeryczne całkowanie można przybliżyć do sumy

% figure;
% plot(t(1:100),x(1:100)); grid; title('Sygnal x(t)'); xlabel('czas [s]'); ylabel('Amplituda');

% czestotliwosc chwilowa (pochodna fazy)
figure;
fi = fc + kF * mF;
plot(t, fi);
xlabel('Czas [s]');
ylabel('Częstotliwość chwilowa [Hz]');
title('Częstotliwość chwilowa sygnału FM');



% sygnal FM: A*cos(2pi*f*t + 2pi*k*calka(m(t)dt)
% numeryczne calkowanie za pomoca sumy kumulacyjnej
% calka(m(t)dt) = suma(m(i) * Ts = 1/fs * suma(m(i))

% modulacja AM-FM - modulujemy aplitude i częstotliwość
% x2=sin(2*pi*1*t);
% x6=sin(2*pi*(10*t-(9/(2*pi*1)*cos(2*pi*1*t)))); % sinus. FM: 9Hz wokol 10Hz 1x na sec 
% x7=sin(2*pi*(10*t+9*cumsum(x2)*dt));            % to samo co x6; dlaczego?
% x = x6;

% plot(t,x,'o-'); grid; title('Sygnal x(t)'); xlabel('czas [s]'); ylabel('Amplituda'); 

% soundsc(x, fpr);