
% syntezowanie za pomoca re-pobudzenia sygnalem bledu e

clear all; close all;

[x,fpr] = audioread('mowa1.wav');
% soundsc(x); pause;

N=length(x); % długość sygnału
Mlen=240; % długość okna Hamminga (liczba próbek)
Mstep=180; % przesunięcie okna w czasie (liczba próbek)
Np=10; % rząd filtra predykcji
% gdzie=181; % początkowe położenie pobudzenia dźwięcznego
lpc=[]; % tablica na współczynniki modelu sygnału mowy
s=[]; % cała mowa zsyntezowana
% ss=[]; % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np); % bufor na fragment sygnału mowy
Nramek=floor((N-240)/180+1); % ile fragmentów (ramek) jest do przetworzenia

resztkowe_all = cell(Nramek, 1); % sygnaly resztkowe z kazdej ramki
all_wzms = zeros(Nramek, 1);
all_as = zeros(Nramek, Np);

% x=filter([1 -0.9735], 1, x); % filtracja wstępna (preemfaza) − opcjonalna

for nr = 1 : Nramek
    % pobierz kolejny fragment sygnału
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);

    % ANALIZA − wyznacz parametry modelu ------------------------------------
    bx = bx - mean(bx); % usuń wartość średnią
    r = zeros(1, Mlen);
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end

    % offset=20; rmax=max( r(offset : Mlen) ); % znajdź maksimum funkcji autokorelacji
    % imax=find(r==rmax); % znajdź indeks tego maksimum
    % if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
    % if (T>80) T=round(T/2); end % znaleziono drugą podharmoniczną
    % T % wyświetl wartość T

    rr(1:Np,1)=(r(2:Np+1))';
    R = zeros(Np, Np);
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr; % oblicz współczynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a; % oblicz wzmocnienie
    % H=freqz(1,[1;a]); % oblicz jego odp. częstotliwościową

    all_as(nr,:) = a';

    % filtr odwrotny
    resztkowy = filter([1; a], 1, bx);
    resztkowe_all{nr} = resztkowy;

    current_resztkowy = resztkowe_all{nr};
    current_a = all_as(nr,:)'; % a jest kolumna

    ss = zeros(1, Mstep);
    bs_synth = zeros(1,Np);

    % bierzemy 180 
    excitation_segment = current_resztkowy(1:min(Mstep, length(current_resztkowy)));

    for n = 1:Mstep
        pob = 0;
        if n <= length(excitation_segment)
            pob = current_resztkowy(n);
        end

        ss(n) = wzm * pob - bs_synth * a;
        bs_synth = [ss(n) bs_synth(1:Np-1)];
    end

    s = [s ss];
end

% s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) − filtr odwrotny − opcjonalny
plot(s); title('mowa zsyntezowana (z pełnym sygnałem resztkowym)');
% soundsc(s(1:floor(end/4))); pause;
soundsc(s);