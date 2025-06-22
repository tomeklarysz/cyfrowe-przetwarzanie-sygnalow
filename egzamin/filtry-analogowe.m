% FILTRY ANALOGOWE

% H(s) = Y(s) ./ X(s)

% |H(f)| (moduł liczby zespolonej) to odpowiedź amplitudowa filtra
% (charakterystyka amplitudowo-czestotliwosciowa)
% (jego wzmocnienie/tłumienie dla składowej o częstotliwości f)
% pokazuje, jak zmienia sie ampituda sygnalu wyjsciowego
% w zaleznosci od czestotliwosci sygnalu wejsciowego

% <H(f) (kąt liczby zespolonej) to odpowiedź fazowa filtra
% (przesunięcie kątowe, przeliczane opóźnienie czasowe)

% zera transmitancji w liczniku Y(s)
% bieguny transmitancji w mianowniku X(s)

% umieszczenie zera transmitancji z1 na osi urojonej jw = j2pif 
% w punkcie z1 = j2pif1 powoduje, ze filtr usuwa z sygnalu skladowa o
% czestotliwosci f1 (bo wtedy |H(f1)| = 0)

% umieszczenie bieguna transmitancji p2 w lewej półpłaszczyźnie, blisko
% osi urojonej jw = j2pif np. w punkcie p2 = -10 + j2pif2 powoduje, ze
% filtr wzmacnia w sygnale czestotliwosc f2, tym bardziej im jest blizej
% osi urojonej