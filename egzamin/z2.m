% DFT
% dyskretna wersja szeregu Fouriera
% przekształcenie próbek sygnału (skończonego ciągu liczb) do
% dziedziny częstotliwości.
% DFT mówi nam: co się dzieje w częstotliowściach dla konkretnego fragmentu
% sygnału
% 
% DFT to rodzaj transformacji ortogonalnej sygnału
% Ortogonalna oznacza, że funkcje bazowe, na które rozkładamy sygnał, są niezależne od siebie
% wykorzystuje zespolone funkcje harmoniczne vk jako elementarne funkcje bazowe
% 
% sygnał x(t) jest przedstawiany jako suma przeskalowanych funkcji bazowych
% próbujemy "odtworzyć" oryginalny sygnał x(t) poprzez dodawanie do siebie
% różnych funkcji harmonicznych (vk(t)), każdą z nich pomnożoną przez
% odpowiedni współczynnik
% ck to współczynniki skalarne, które mówią, jak dużo danej funkcji bazowej
% vk(t) jest w sygnale x(t)
% jeśli x(t) zawiera dużo danej częstotliwości fk (czyli jest podobny do
% vk(t) o tej częstotliwości), to iloczyn vk(t)x(t) będzie duży, więc ck
% będzie duży. jeśli x(t) nie zawiera danej częstotliwości, to iloczyn
% będzie bliski zeru, a ck również będzie bliski zeru


% DtFT
% dyskretna w czasie transformata Fouriera
% zdyskretyzowana ciągła transformacja Fouriera (czyli zdyskretyzowana
% klasyczna transformata Fouriera)
% przekształcenie nieskończonego lub bardzo długiego ciągu w funkcję
% czestotliwościową, ale wynik jest ciągły w dziedzinie częstotliwości.
% DtFT: ciągłe widmo nieskończonego sygnału dyskretnego
