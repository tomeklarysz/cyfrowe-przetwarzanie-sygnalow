% FILTRY CYFROWE IIR

% ich odpowiedź impulsowa (reakcja filtru na impuls Diraca) 
% teoretycznie trwa nieskończenie długo, stopniowo zanikając, 
% ale nigdy całkowicie nie osiągając zera.

% obecność sprzężenia zwrotnego, a więc bieżąca wartość wyjściowa filtru
% zależy nie tylko od obecnych i poprzednich wartości wejściowych, ale
% także od poprzednich wartości wyjściowych filtru

% Stabilność filtru IIR zależy od położenia biegunów w płaszczyźnie Z. 
% Aby filtr był stabilny, wszystkie jego bieguny muszą leżeć wewnątrz 
% okręgu jednostkowego (tj. ich moduły muszą być mniejsze od 1).

% Ponieważ filtr IIR "zapamiętuje" poprzednie stany wyjściowe i 
% wykorzystuje je do obliczania kolejnych, impuls Diraca podany na 
% wejście spowoduje, że sygnał wyjściowy będzie trwał teoretycznie 
% w nieskończoność (choć w praktyce będzie zanikał do poziomu szumów).

% Zalety filtrów IIR:
% Efektywność obliczeniowa: Aby uzyskać daną charakterystykę częstotliwościową (np. stromość zbocza), 
% filtry IIR wymagają znacznie niższego rzędu (czyli mniej współczynników i mniej operacji obliczeniowych) 
% niż filtry FIR. To sprawia, że są bardziej wydajne pod względem zasobów procesora i pamięci.
% 
% Łatwiejsze projektowanie z użyciem prototypów analogowych: Wiele metod projektowania filtrów IIR 
% opiera się na transformacjach cyfrowych analogowych filtrów (np. Butterwortha, Czebyszewa, Bessela), 
% które są dobrze znane i opracowane. Upraszcza to proces projektowania.
% 
% Dobra aproksymacja charakterystyk analogowych: Dzięki swojej strukturze rekursywnej filtry IIR są w 
% stanie bardzo dobrze naśladować charakterystyki filtrów analogowych.


% Wady filtrów IIR:
% Nieliniowa charakterystyka fazowa: W przeciwieństwie do filtrów FIR o liniowej fazie, 
% filtry IIR zazwyczaj wprowadzają nieliniowe opóźnienie fazowe. Może to prowadzić do 
% zniekształceń sygnału, szczególnie w zastosowaniach audio i wideo, gdzie precyzyjne zachowanie fazy jest ważne.
% 
% Problemy ze stabilnością: Ze względu na sprzężenie zwrotne, filtry IIR mogą stać się niestabilne, 
% jeśli ich współczynniki zostaną źle dobrane lub jeśli wystąpią błędy kwantyzacji (zaokrągleń) w implementacji.
% Niestabilny filtr będzie generował sygnał wyjściowy, który rośnie do nieskończoności, nawet dla ograniczonego sygnału wejściowego.
% 
% Złożoność projektowania w dziedzinie cyfrowej: Chociaż istnieją metody oparte na filtrach analogowych, 
% projektowanie filtrów IIR bezpośrednio w dziedzinie cyfrowej (przez umiejscowienie zer i biegunów) 
% może być bardziej skomplikowane niż w przypadku filtrów FIR.
% 
% Trudniejsze uzyskanie zerowej fazy: Osiągnięcie zerowego przesunięcia fazowego w filtrach IIR jest 
% trudniejsze i zazwyczaj wymaga przetwarzania sygnału w przód i w tył (co nie jest możliwe w czasie rzeczywistym).