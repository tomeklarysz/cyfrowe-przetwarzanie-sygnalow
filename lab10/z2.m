clear all; close all;

[x,fpr]=audioread('mowa1.wav'); % wczytaj sygnał mowy (cały)
% plot(x); title('sygnał mowy'); pause % pokaż go
soundsc(x,fpr); % oraz odtwórz na głośnikach (słuchawkach) 
pause;

[cold, ~] = audioread('coldvox.wav');
cold = cold(:)';

N=length(x); % długość sygnału
Mlen=240; % długość okna Hamminga (liczba próbek)
Mstep=180; % przesunięcie okna w czasie (liczba próbek)
Np=10; % rząd filtra predykcji 
gdzie=Mstep+1; % początkowe położenie pobudzenia dźwięcznego

lpc=[]; % tablica na współczynniki modelu sygnału mowy
s=[]; % cała mowa zsyntezowana
ss=[]; % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np); % bufor na fragment sygnału mowy
Nramek=floor((N-240)/180+1); % ile fragmentów (ramek) jest do przetworzenia

% figure;
% subplot(2,1,1); plot(x); title('Przed preemfazą');
% subplot(2,1,2); pwelch(x); title('Widmo mocy');

x=filter([1 -0.9735], 1, x); % filtracja wstępna (preemfaza) − opcjonalna

% figure;
% subplot(2,1,1); plot(x); title('Po preemfazie');
% subplot(2,1,2); pwelch(x); title('Widmo po preemfazie');

for wariant = 1:4
for nr = 1 : Nramek
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    % figure;
    % subplot(2,1,1); plot(x_s); title('Przed preemfazą');
    % subplot(2,1,2); pwelch(x_s); title('Widmo mocy');

    x=filter([1 -0.9735], 1, x); % filtracja wstępna (preemfaza) − opcjonalna

    % figure;
    % subplot(2,1,2); plot(x_s); title('Po preemfazie');
    % subplot(2,1,2); pwelch(x_s); title('Widmo po preemfazie');
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
    if ( rmax > 0.3*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
    if (T>80) T=round(T/2); end % znaleziono drugą podharmoniczną
    
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))]; % zbuduj macierz autokorelacji
    end
    
    % wspolczynniki filtra LPC 
    a=-inv(R)*rr; % oblicz współczynniki filtra predykcji
    % a = -pinv(R) * rr;
    wzm=r(1)+r(2:Np+1)*a; % oblicz wzmocnienie
    H=freqz(1,[1;a]); % oblicz jego odp. częstotliwościową
    % lpc=[lpc; T; wzm; a; ]; % zapamiętaj wartości parametrów
    
    switch wariant
        case 1
            T = 0;
        case 2
            if T ~= 0
                T = 2*T;
            end
        case 3
            if T ~= 0
                T = 80;
            end
        case 4
            T = 0;
    end

    % SYNTEZA − odtwórz na podstawie parametrów ---------------------------------------------------------------------
    % T = 80; % usuń pierwszy znak „%” i ustaw: T = 80, 50, 30, 0
    if (T~=0) gdzie=gdzie-Mstep; end % „przenieś” pobudzenie dźwięczne 
    index = 1;
    for n=1:180
        if( T==0)
            if (wariant == 4)
                pob = cold(index);
                index = index + 1;
                if index > length(cold)
                    index = 1;
                end
            else
                pob=2*(rand(1,1)-0.5); gdzie=271; % pobudzenie szumowe
            end
        else
            if (n==gdzie) pob=1; gdzie=gdzie+T; % pobudzenie dźwięczne 
            else pob=0; end
        end
        ss(n)=wzm*pob-bs*a; % filtracja „syntetycznego” pobudzenia
        bs=[ss(n) bs(1:Np-1) ]; % przesunęcie bufora wyjściowego
    end
    % subplot(414); plot(ss); title(‘zsyntezowany fragment sygnału mowy’); pause
    s = [s ss]; % zapamiętanie zsyntezowanego fragmentu mowy

    s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) − filtr odwrotny − opcjonalny
    
    % figure;
    % subplot(411); plot(abs(H)); title('widmo filtra traktu głosowego');
    
    % sygnał czasowy przed i po progowaniu,
    % subplot(412); plot(bx); title('sygnał czasowy przed i po progowaniu')
    
    % funkcja autokorelacji sygnału z zaznaczonymi progami,
    % figure;
    % subplot(413); plot(r); hold on;
    % title('funkcja autokorelacji z programi');
    % yline(0.3*r(1), '--r', 'Próg decyzji');
    % 
    % figure;
    % subplot(211); plot(x_s); title('ramka oryginalna');
    % subplot(212); plot(s); title('ramka zsyntezowana'); pause
end
    soundsc(s, fpr); 
    pause(2);
end