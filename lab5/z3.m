clear all; close all;
fs = 256e3;
An = 40;    % najwieksze tlumienie dla 128kHz
Ap = 3;     % tlumienie dla < 64kHz
pass = 64e3;
stop = 128e3;

f = 0:1:300e3;
w = 2*pi*f;
s = j*w;

% Butterworth

% najnizszy mozliwy rzad
[n,Wn] = buttord(2*pi*pass,2*pi*stop,Ap,An,'s');

[b,a] = butter(n, 2*pi*pass, 's');

H1 = polyval(b,s)./ polyval(a,s);
H1 = H1/max(H1);
% 
% figure('Name', 'Filtr Butterworth');
% plot(f,20*log10(abs(H1)),'b'); grid;
% title('|H(f)| [dB] (oś f w skali log)');
% xlabel('Częstotliwość [Hz]');
% 
% p = roots(a);
% figure;
% plot(real(p), imag(p), 'x'); grid;
% title('Rozkład biegunów Butterworth');

H1log = 20*log10(abs(H1));
fprintf('Zafalowania Butterworth dla 64kHz: %f\n',H1log(pass));
fprintf('Tłumienie Butterwoth dla 128kHz: %f\n',H1log(stop));
fprintf('\n');

% Czebyszew 1

% najnizszy mozliwy rzad
[n,Wn] = cheb1ord(2*pi*pass,2*pi*stop,Ap,An,'s');

[b,a] = cheby1(n, 3, 2*pi*pass, 's');

H2 = polyval(b,s)./ polyval(a,s);
H2 = H2/max(H2);

% figure('Name', 'Filtr Czebyszew 1');
% plot(f,20*log10(abs(H2)),'b'); grid;
% title('|H(f)| [dB] (oś f w skali log)');
% xlabel('Częstotliwość [Hz]');

% p = roots(a);
% figure;
% plot(real(p), imag(p), 'x'); grid;
% title('Rozkład biegunów Czebyszew 1');

H2log = 20*log10(abs(H2));
fprintf('Zafalowania Czebyszew 1 dla 64kHz: %f\n',H2log(pass));
fprintf('Tłumienie Czebyszew 1 dla 128kHz: %f\n',H2log(stop));
fprintf('\n');

% Czebyszew 2

% najnizszy mozliwy rzad
[n,Wn] = cheb2ord(2*pi*pass,2*pi*stop,Ap,An,'s');

[b,a] = cheby2(n, 40, 2*pi*stop, 's');

H3 = polyval(b,s)./ polyval(a,s);
H3 = H3/max(H3);

% figure('Name', 'Filtr Czebyszew 2');
% plot(f,20*log10(abs(H3)),'b'); grid;
% title('|H(f)| [dB] (oś f w skali log)');
% xlabel('Częstotliwość [Hz]');
% 
% p = roots(a);
% figure;
% plot(real(p), imag(p), 'x'); grid;
% title('Rozkład biegunów Czebyszew 2');

H3log = 20*log10(abs(H3));
fprintf('Zafalowania Czebyszew 2 dla 64kHz: %f\n',H3log(pass));
fprintf('Tłumienie Czebyszew 2 dla 128kHz: %f\n',H3log(stop));
fprintf('\n');

% eliptyczny

% najnizszy mozliwy rzad
[n,Wn] = ellipord(2*pi*pass,2*pi*stop,Ap,An,'s');

[b,a] = ellip(n, 3, 40, 2*pi*pass, 's');

H4 = polyval(b,s)./ polyval(a,s);
H4 = H4/max(H4);

% figure('Name', 'Filtr Eliptyczny');
% plot(f,20*log10(abs(H4)),'b'); grid;
% title('|H(f)| [dB] (oś f w skali log)');
% xlabel('Częstotliwość [Hz]');
% 
% p = roots(a);
% figure;
% plot(real(p), imag(p), 'x'); grid;
% title('Rozkład biegunów filtr eliptyczny');

H4log = 20*log10(abs(H4));
fprintf('Zafalowania filtr eliptyczny dla 64kHz: %f\n',H4log(pass));
fprintf('Tłumienie filtr eliptyczny dla 128kHz: %f\n',H4log(stop));
fprintf('\n');

% wszystko na jednym, dodac legende
figure; grid;
hold on;
plot(f,20*log10(abs(H1)));
plot(f,20*log10(abs(H2)));
plot(f,20*log10(abs(H3)));
plot(f,20*log10(abs(H4)));
legend('Butterworth','Czebyszew 1','Czebyszew 2','Eliptyczny');