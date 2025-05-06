clear all; close all;

load("lab08_am.mat");
x = s1;

M = 20;                             % polowa dlugosci filtra
N=2*M+1; n = 1 : M;

h = (2/pi) * sin(pi*n/2).^2 ./ n;   % polowa dlugosci impulsowej
h = [ -h(M:-1:1) 0 h(1:M) ];        % cala odpowiedz

w = blackman(N); w=w';              % okno Blackmana
hw = h .* w;                        % wymnożenie odpowiedzi impulsowej z oknem

m = -M : 1 : M;                    % dla filtra nieprzyczynowego (bez przesunięcia o M próbek w prawo)
NF=500; fn=0.5*(1:NF-1)/NF;
for k=1:NF-1
    H(k)=sum( h .* exp(-j*2*pi*fn(k)*m) );
    HW(k)=sum( hw .* exp(-j*2*pi*fn(k)*m) );
end

% stem(m,h); grid; title('h(n)'); xlabel('n'); pause
% stem(m,hw); grid; title('hw(n)'); xlabel('n'); pause
% plot(fn,abs(H)); grid; title('|H(fn)|'); xlabel('f norm]'); pause
% plot(fn,abs(HW)); grid; title('|HW(fn)|'); xlabel('f norm]'); pause
% plot(fn,unwrap(angle(H))); grid; title('kąt H(fn) [rd]'); xlabel('f norm'); pause
% plot(fn,unwrap(angle(HW))); grid; title('kąt HW(fn) [rd]'); xlabel('f norm'); pause

Nx=1000; fx=200; fpr=1000; n=0:Nx-1;

y=conv(x,hw); % filtracja sygnału x(n) za pomocą odp. impulsowej hw(n); otrzymujemy Nx+N−1 próbek
y=y(N:Nx); % odcięcie stanów przejściowych (po N−1 próbek) z przodu i z tyłu sygnału y(n)
xp=x(M+1:Nx-M); % odcięcie tych próbek z x(n), dla których nie ma poprawnych odpowiedników w y(n)

m = sqrt(xp.^2 + y.^2);     % obwiednia

% N = length(m);
% f = (0:N-1)*(fpr/N);
% x_mod = abs(fft(m));
% plot(f,x_mod);

%% FFT obwiedni
NFFT = 2^nextpow2(fpr);
Y    = fft(m,NFFT)/fpr;                  %transformata fouriera obwiedni
f    = fpr/2*linspace(0,1,NFFT/2+1);

figure;
hold on;
plot(xp(1:200),'b'); 
plot(y(1:200),'k');
plot(m(1:200),'r'); 
title('Przedstawienie sygnału z pliku, jego transformaty i obwiedni (fragment)');
legend('x','HT(x)','obwiednia');
hold off;

figure('Name','FFT obwiedni')
plot(f,2*abs(Y(1:NFFT/2+1)),'b');
title('FFT obwiedni');

%% Odczytanie parametrów sygnału modulującego m(t)
[pks, locs] = findpeaks(2*abs(Y(1:NFFT/2+1)), 'SortStr','descend');

% Odczytanie częstotliwości i amplitud z FFT obwiedni
f1 = fn(locs(1));  f2 = fn(locs(2));  f3 = fn(locs(3));
A1 = pks(1);       A2 = pks(2);       A3 = pks(3);

%% Wyświetlenie parametrów
disp(['Częstotliwość f1: ' num2str(f1)]);
disp(['Częstotliwość f2: ' num2str(f2)]);
disp(['Częstotliwość f3: ' num2str(f3)]);
disp(['Amplituda A1: ' num2str(A1)]);
disp(['Amplituda A2: ' num2str(A2)]);
disp(['Amplituda A3: ' num2str(A3)]);