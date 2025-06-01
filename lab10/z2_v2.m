clear all; clf;

[x, fpr] = audioread('mowa1.wav');  % Wczytaj sygnał mowy
N = length(x);
Mlen = 240;
Mstep = 180;
Np = 10;

[cold, ~] = audioread('coldvox.wav');
cold = cold(:)';  % upewnij się, że to wektor wierszowy

for wariant = 1:4
    fprintf('WARIANT %d\n', wariant);
    s = [];                            % zsyntezowany sygnał
    bs = zeros(1, Np);                % bufor wyjściowy
    gdzie = Mstep + 1;                % początkowa pozycja pobudzenia
    index = 1;                          % indeks do coldvox

    Nramek = floor((N - Mlen) / Mstep + 1);

    for nr = 1:Nramek
        n = 1 + (nr - 1) * Mstep : Mlen + (nr - 1) * Mstep;
        bx = x(n);
        bx = bx - mean(bx);

        for k = 0:Mlen-1
            r(k+1) = sum(bx(1:Mlen-k) .* bx(1+k:Mlen));
        end

        offset = 20; 
        rmax = max(r(offset:Mlen)); 
        imax = find(r == rmax, 1); 
        if rmax > 0.35 * r(1)
            T = imax;
        else
            T = 0;
        end

        rr = r(2:Np+1)'; 
        for m = 1:Np
            R(m, :) = [r(m:-1:2), r(1:Np-(m-1))];
        end

        a = -inv(R) * rr;
        wzm = r(1) + r(2:Np+1) * a;

        switch wariant
            case 1  % pobudzenie = szum
                T = 0;

            case 2  % gloski dzwieczne: obniż częstotliwość podstawową dwukrotnie
                if T ~= 0
                    T = 2 * T;
                end

            case 3  % gloski dzwieczne: ustaw stałe T = 80
                if T ~= 0
                    T = 80;
                end

            case 4  % bezdźwięczne, ale pobudzenie = coldvox
                T = 0;
        end

        % SYNTEZA
        for n = 1:Mstep
            if T == 0
                if wariant == 4
                    pob = cold(index);
                    index = index + 1;
                    if index > length(cold)
                        index = 1;
                    end
                else
                    pob = 2 * (rand(1,1) - 0.5);
                end
            else
                if n == gdzie
                    pob = 1;
                    gdzie = gdzie + T;
                else
                    pob = 0;
                end
            end
            ss(n) = wzm * pob - bs * a;
            bs = [ss(n), bs(1:Np-1)];
        end
        s = [s, ss];
    end

    subplot(4,1,wariant);
    plot(s);
    title(['Wariant ' num2str(wariant)]);
    soundsc(s, fpr); 
    pause;
end
