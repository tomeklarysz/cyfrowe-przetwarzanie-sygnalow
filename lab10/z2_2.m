clear all; close all;

[x,fpr] = audioread('mowa1.wav');
soundsc(x(1:floor(end/4))); pause;

N=length(x); % długość sygnału
Mlen=240; % długość okna Hamminga (liczba próbek)
Mstep=180; % przesunięcie okna w czasie (liczba próbek)
Np=10; % rząd filtra predykcji
gdzie=181; % początkowe położenie pobudzenia dźwięcznego

lpc=[]; % tablica na współczynniki modelu sygnału mowy
s=[]; % cała mowa zsyntezowana
ss=[]; % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np); % bufor na fragment sygnału mowy
Nramek=floor((N-240)/180+1); % ile fragmentów (ramek) jest do przetworzenia

% x=filter([1 -0.9735], 1, x); % filtracja wstępna (preemfaza) − opcjonalna

% for nr = 1 : Nramek
nr = 25;
% pobierz kolejny fragment sygnału 
n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
bx = x(n);
% ANALIZA − wyznacz parametry modelu -------------------------------------------------------------------------------
bx = bx - mean(bx); % usuń wartość średnią
for k = 0 : Mlen-1
    r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
end

% subplot(411); plot(n,bx); title(‘fragment sygnału mowy’);
% subplot(412); plot(r); title(‘jego funkcja autokorelacji’);
offset=20; rmax=max( r(offset : Mlen) ); % znajdź maksimum funkcji autokorelacji
imax=find(r==rmax); % znajdź indeks tego maksimum
if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
if (T>80) T=round(T/2); end % znaleziono drugą podharmoniczną
% T % wyświetl wartość T
rr(1:Np,1)=(r(2:Np+1))';
for m=1:Np
    R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji
end
a=-inv(R)*rr; % oblicz współczynniki filtra predykcji
wzm=r(1)+r(2:Np+1)*a; % oblicz wzmocnienie
H=freqz(1,[1;a]); % oblicz jego odp. częstotliwościową

resztka = filter([1; a], 1, x(n)); 
ile_okresow = 4;
resztka_srednia = mean(reshape(resztka(1:T*ile_okresow), T, ile_okresow), 2)';

% subplot(413); plot(abs(H)); title(‘widmo filtra traktu głosowego’);
% lpc=[lpc; T; wzm; a; ]; % zapamiętaj wartości parametrów

% SYNTEZA − odtwórz na podstawie parametrów ---------------------------------------------------------------------
% T = 0; % usuń pierwszy znak „%” i ustaw: T = 80, 50, 30, 0
if (T~=0) gdzie=gdzie-Mstep; end % „przenieś” pobudzenie dźwięczne 
for n=1:180
    if( T==0)
        pob=2*(rand(1,1)-0.5); gdzie=271; % pobudzenie szumowe
    else
        pob = resztka_srednia(mod(gdzie-1, T) + 1);
        gdzie = gdzie + 1;
    end
    ss(n)=wzm*pob-bs*a; % filtracja „syntetycznego” pobudzenia
    bs=[ss(n) bs(1:Np-1) ]; % przesunęcie bufora wyjściowego
end

% subplot(414); plot(ss); title(‘zsyntezowany fragment sygnału mowy’); pause
s = [s ss]; % zapamiętanie zsyntezowanego fragmentu mowy
% s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) − filtr odwrotny − opcjonalny
plot(s); title('mowa zsyntezowana'); 
soundsc(s(1:floor(end/4))); pause