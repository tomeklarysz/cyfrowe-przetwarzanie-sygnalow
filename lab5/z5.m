clear all; close all;

f0 = 96e6;
f = 90e6:100:102e6;
w = 2*pi*f;
s = j*w;
Ap = 3;
An = 40;

% filtr +- 1MHz
pass = [2*pi*95e6 2*pi*97e6];
stop = [2*pi*94e6 2*pi*98e6];


figure;
for i=2:1:7
    n = i;
    [b,a] = cheby1(n,Ap,pass,'bandpass','s');
    H = polyval(b,s) ./ polyval(a,s);
    H = H/max(H);
    Hlog = 20*log10(abs(H));
    plot(f,Hlog); title('Testowy (różne N)'); xlabel('f [Hz]'); grid; hold on;
    ylabel('H(f)');
end
legend('N = 2','N = 3','N = 4','N = 5','N = 6','N = 7');

% najnizszy mozliwy rzad i czestotliwosci graniczne
[n,Wn] = cheb1ord(pass,stop,Ap,An,'s');

[b,a] = cheby1(n,Ap,Wn,'bandpass','s');

H = polyval(b,s) ./ polyval(a,s);
H = H/max(H);
Hlog = 20*log10(abs(H));

figure;
plot(f,Hlog); title('Testowy'); xlabel('f [Hz]');
ylabel('H(f)'); grid;

% filtr +- 100kHz
pass = [2*pi*95.9e6 2*pi*96.1e6];
stop = [2*pi*95e6 2*pi*97e6];

figure;
for i=2:1:7
    n = i;
    [b,a] = cheby1(n,Ap,pass,'bandpass','s');
    H = polyval(b,s) ./ polyval(a,s);
    H = H/max(H);
    Hlog = 20*log10(abs(H));
    plot(f,Hlog); title('Docelowy(różne N)'); xlabel('f [Hz]'); grid; hold on;
    ylabel('H(f)');
end
legend('N = 2','N = 3','N = 4','N = 5','N = 6','N = 7');

% najnizszy mozliwy rzad
[n,Wn] = cheb1ord(pass,stop,Ap,An,'s');
fprintf("N = %d\n",n);

[b,a] = cheby1(n,Ap,Wn,'bandpass','s');

H = polyval(b,s) ./ polyval(a,s);
H = H/max(H);
Hlog = 20*log10(abs(H));

figure;
plot(f,Hlog); title('Docelowy'); xlabel('f [Hz]');
ylabel('H(f)'); grid;

% fprintf('Zafalowania dla 96MHz: %f\n',Hlog(96e6));
% fprintf('Tłumienie dla 98MHz %f\n',Hlog(98e6));