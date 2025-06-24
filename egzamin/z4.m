% Filtr adaptacyjny to bloczek obliczeniowy mający 2 sygnały
% wejściowe:
% 1. d(n) - odniesienia
% 2. x(n) - adaptacyjnie filtrowany
% oraz 2 sygnały wyjściowe:
% 1. y(n) = adapt[x(n)] - wynik filtracji sygnału x(n)
% 2. e(n) = d(n) - y(n) - sygnał błędu/niedopasowania

% Zadaniem filtra jest spowodowanie, aby sygnał x(n) 
% po filtracji upodobnił się do sygnału d(n): y(n) -> d(n)
% Adaptacyjna zmiana wag filtra i w konsekwencji jego charakterystyki
% częstotliwościowej