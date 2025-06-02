clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav');	      % wczytaj sygnał mowy (cały)
doplots = 1;

gloska_dzw = 3200:3600;
% soundsc(x(gloska_dzw),fpr);

gloska_bez = 37460:37860;
%soundsc(x(gloska_bez),fpr);      

stan_przej = 3670:4070;      %stan przejściowy
% soundsc(x(stan_przej), fpr);

x = x(gloska_dzw); doplots=1;
% x = x(gloska_bez); doplots=1;
% x = x(stan_przej); doplots=1;
x_og = x;

quantize = 1;

% figure; 
subplot(221); plot(x); title('sygnał mowy'); 	% pokaż go
% figure; 
subplot(223); pwelch(x, [], [], [], fpr); % domyślne parametry, wyświetlenie PSD
% jak moc sygnału jest rozłożona na poszczególne składowe częstotliwościowe

N=length(x);	  % długość sygnału
Mlen=240;		  % długość okna Hamminga (liczba próbek)
Mstep=180;		  % przesunięcie okna w czasie (liczba próbek)
Np=10;			  % rząd filtra predykcji
gdzie=Mstep+1;	  % początkowe położenie pobudzenia dźwięcznego

lpc=[];								   % tablica na współczynniki modelu sygnału mowy
s=[];									   % cała mowa zsyntezowana
ss=[];								   % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygnału mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragmentów (ramek) jest do przetworzenia

x=filter([1 -0.9735], 1, x);	% filtracja wstępna (preemfaza) - opcjonalna
% figure; 
subplot(222); plot(x); title('sygnał mowy po preemfazie'); 	% pokaż go
% figure;
subplot(224); pwelch(x, [], [], [], fpr);


% progowanie sygnału x:
% progowanie ogranicza amplitude probek ktore sa poza pewnym progiem
x_prog = zeros(length(x), 1);

for n=1:length(x)
    if mod(n-1, Mstep) == 0 && n+Mlen<=length(x)         % Jeśli przeszliśmy do kolejnej ramki, obliczamy nowe P
        P = 0.3*max(x(n:n+Mlen));                        % Progujemy kazda ramke z osobna?
    end
    
    if x(n) >= P
        x_prog(n) = x(n) - P;
    elseif x(n) <= -P
        x_prog(n) = x(n) + P;
    else
        x_prog(n) = 0;
    end
end

x = x_prog;

figure; 
subplot(211); plot(x); title('sygnał mowy po progowaniu'); 	% pokaż go
subplot(212); pwelch(x, [], [], [], fpr);


for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygnału
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    bx = bx - mean(bx);  % usuń wartość średnią
    for k = 0 : Mlen-1
        % measures the similarity between a signal and a delayed version of itself.
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    % subplot(411); plot(n,bx); title('fragment sygnału mowy');
    if (doplots)
        figure; plot(r); title('jego funkcja autokorelacji'); yline(0.35*r(1))
    end

    offset=20; rmax=max( r(offset : Mlen) );	   % znajdź maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajdź indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
    if (T>80) T=round(T/2); end							% znaleziono drugą podharmoniczną
    T				   							% wyświetl wartość T
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    
    % wspolczynniki filtru ktory modeluje trakt glosowy
    a=-inv(R)*rr;											% oblicz współczynniki filtra predykcji


    % kwantyzacja
    if (quantize)
        n_bit_arr = [8,6,6,4,4];
        n_bit_arr = [4,6,4,6,8];
        for it=1:floor(length(a)/2)
            n_bit = n_bit_arr(it);
            a(2*it-1) = round(a(2*it-1)*2^n_bit) / 2^n_bit;
            a(2*it) = round(a(2*it)*2^n_bit) / 2^n_bit;
        end
    end
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);										% oblicz jego odp. częstotliwościową
    figure; plot(abs(H)); title('widmo filtra traktu głosowego');

    % lpc=[lpc; T; wzm; a; ];								% zapamiętaj wartości parametrów
    
    % SYNTEZA - odtwórz na podstawie parametrów ----------------------------------------------------------------------
    if (T~=0) gdzie=gdzie-Mstep; end					% przemieść pobudzenie dźwięczne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            pob=2*(rand(1,1)-0.5); gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            if (n==gdzie) pob=1; gdzie=gdzie+T;	   % pobudzenie dźwięczne
            else pob=0; end
        end
        ss(n)=wzm*pob-bs*a;		% filtracja „syntetycznego” pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesunięcie bufora wyjściowego
    end
    s = [s ss];						% zapamiętanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure; 
subplot(211); plot(s); title('mowa zsyntezowana'); 
subplot(212); plot(x_og); title('sygnal oryginalny');
% subplot(223); pwelch(s, [], [], [], fpr);
pause;
soundsc(s, fpr)
% audiowrite("out.wav", s, fpr)