close all;

[x,fpr]=audioread('mowa1.wav');	      % wczytaj sygnał mowy (cały)

gloska_dzw = 3200:3600;
% soundsc(x(gloska_dzw),fpr);

gloska_bez = 37460:37860;
%soundsc(x(gloska_bez),fpr);      

stan_przej = 3670:4070;      %stan przejściowy
% soundsc(x(stan_przej), fpr);

x = x(1:(end/2));
% x = x(gloska_dzw);
% x = x(gloska_bez);
% x = x(stan_przej);
x_og = x;

quantize_flag = 1;

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
        P = 0.3*max(x(n:n+Mlen));                       
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
subplot(211); plot(x); title('sygnał mowy po progowaniu');
subplot(212); pwelch(x, [], [], [], fpr);

% n_bit_arr_pairs = [8, 6, 6, 4, 4];
% n_bit_arr_pairs = [4, 6, 6, 4, 2];
% n_bit_arr_pairs = [6, 4, 4, 4, 2];
% n_bit_arr_pairs = [8, 8, 6, 4, 2];
n_bit_arr_pairs = [4, 6, 4, 6, 8];
fprintf('liczba bitow na wspolczynniki: ');
display(n_bit_arr_pairs);
bits_frame = sum(n_bit_arr_pairs) + 8 + 6;
frames_per_second = fpr / Mstep;
bitrate = bits_frame * frames_per_second;
fprintf('\nprzeplywnosc bitowa = %.4f bps\n', bitrate);
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
    % figure; plot(r); title('jego funkcja autokorelacji'); yline(0.35*r(1))

    offset=20; rmax=max( r(offset : Mlen) );	   % znajdź maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajdź indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
    if (T>80) T=round(T/2); end							% znaleziono drugą podharmoniczną
    T;				   							% wyświetl wartość T
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    
    % wspolczynniki filtru ktory modeluje trakt glosowy
    a_unquantized = -inv(R)*rr;							% oblicz współczynniki filtra predykcji
    % a = -inv(R)*rr;
 
    % kwantyzacja
    if (quantize_flag)

        % pierwiastki wielomianu (filtra) i 1 na poczatku
        roots_unquantized = roots([1; a_unquantized]);

        % pary sprzezone zespolonych pierwiastkow
        % cplxpair sortuje pierwiastki i grupuje sprzężone pary
        roots_paired = cplxpair(roots_unquantized);

        roots_quantized = zeros(size(roots_paired));

        pair_idx = 0;                       % Indeks dla tablicy n_bit_arr_pairs
        for k = 1:2:length(roots_paired)    % Iteruj po parach pierwiastków
            pair_idx = pair_idx + 1;
            if pair_idx > length(n_bit_arr_pairs)
                % Jeśli zabraknie bitów w tablicy, użyj ostatniej wartości lub domyślnej
                current_word_length = n_bit_arr_pairs(end);
            else
                % liczba bitow dla biezacej pary
                current_word_length = n_bit_arr_pairs(pair_idx);
            end

            % kwantujemy czesc rzeczywista i urojona
            % 1 bit na znak, a reszta na czesc ulamka
            fraction_length = current_word_length - 1; 
            nt_real_imag = numerictype('Signed', true, 'WordLength', current_word_length, 'FractionLength', fraction_length);

            % kwantyzujemy pare pierwiastkow
            if isreal(roots_paired(k)) % Jeśli to pierwiastek rzeczywisty

                % roots_quantized(k) = quantize(roots_paired(k), nt_real_imag);

                % konstruktor fi sam w sobie wykonuje kwantyzacje, quantize
                % oczekuje obiektu fi a nie double

                roots_quantized(k) = double(fi(roots_paired(k), nt_real_imag));
                % Jeśli pierwiastek jest rzeczywisty, nie ma pary sprzężonej
            else % Pierwiastek zespolony i jego sprzężenie
                % roots_quantized(k)   = quantize(real(roots_paired(k)), nt_real_imag) + 1i * quantize(imag(roots_paired(k)), nt_real_imag);
                roots_quantized(k)   = double(fi(real(roots_paired(k)), nt_real_imag)) + 1i * double(fi(imag(roots_paired(k)), nt_real_imag));
                roots_quantized(k+1) = conj(roots_quantized(k)); % Upewnij się, że są sprzężone po kwantyzacji
            end

            % Sprawdź stabilność po kwantyzacji (moduł pierwiastka <= 1)
            if abs(roots_quantized(k)) > 1
                % Jeśli pierwiastek wyszedł poza okrąg jednostkowy, przesuń go do środka
                roots_quantized(k) = roots_quantized(k) / abs(roots_quantized(k));
                if ~isreal(roots_quantized(k))
                    roots_quantized(k+1) = conj(roots_quantized(k)); % Zaktualizuj sprzężenie
                end
            end
        end

        % bierzemy wspolczynniki wielomianu
        a_quantized_full = poly(roots_quantized);
        a = a_quantized_full(2:end)';

    else % gdy quantize_flag = 0
        a = a_unquantized;
    end

    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);										% oblicz jego odp. częstotliwościową
    % figure; plot(abs(H)); title('widmo filtra traktu głosowego');

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

% figure; 
% subplot(211); plot(s); title('mowa zsyntezowana'); 
% subplot(212); plot(x_og); title('sygnal oryginalny');
% subplot(223); pwelch(s, [], [], [], fpr);
% pause;
% soundsc(s, fpr);
audiowrite("kwantyzacja5.wav", s, fpr);

% 1: 1866.6667 bps
% 2: 1600 bps
% 3: 1511.1111 bps
% 4: 1866.6667 bps
% 5: 1866.6667 bps