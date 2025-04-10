clear all; close all;
p12 = -0.5 + j*9.5; p12 = [p12, conj(p12)];
p34 = -1 + j*10; p34 = [p34, conj(p34)];
p56 = -0.5 + j*10.5; p56 = [p56, conj(p56)];
p = [p12 p34 p56];
z = [-j*5 j*5 -j*15 j*15]; 

figure; plot(real(z),imag(z),'bo', real(p),imag(p),'r*'); grid;
axis([-2 2 -20 20])
title('Zera (o) i Bieguny (*)'); xlabel('Real()'); ylabel('Imag()'); pause

% w = 0:2:100;
w = 0:0.01:20;
s = j*w;
a = poly(p);
b = poly(z);
H = polyval(b,s) ./ polyval(a,s);

figure; plot(w, abs(H)); xlabel('s = jw [rad/s]'); title('|H(jw)|'); grid; pause;
figure; plot(w,20*log10(abs(H))); xlabel('s = jw [rad/s]'); title('|H(jw)| [dB]'); grid; 
hold on;
[Min, I] = min(20*log10(abs(H)));
[Max, J] = max(20*log10(abs(H))); 
plot(w(I),Min,'ro', w(J),Max,'ro'); hold off; pause;
% figure('Name','Odniesienie'); freqs(b,a); 

figure; plot(w,unwrap(angle(H))); xlabel('s = jw'); title('angle(H(f)) [rad]'); grid; pause;
% Umieszczenie zera transmitancji z1 na osi urojonej jω = j2π f w
% punkcie z1 = j2π f1 powoduje, ze filtr usuwa z sygnału składowa o czestotliwosci 
% f1 (poniewaz wówczas |H(f1)| = 0)

b = b / max(abs(H));
H = polyval(b,s) ./ polyval(a,s);
figure; plot(w, abs(H)); xlabel('s = jw [rad/s]'); title('|H(jw)|'); grid; pause;
figure; plot(w,20*log10(abs(H))); xlabel('s = jw [rad/s]'); title('|H(jw)| [dB]'); grid; 
hold on;
[Min, I] = min(20*log10(abs(H)));
[Max, J] = max(20*log10(abs(H)));
plot(w(I),Min,'ro', w(J),Max,'ro'); hold off; pause;

fprintf('Wyskalowanie\n');
fprintf('Maksymalne tłumienie: %2f\n',Max);
fprintf('Minimalne tłumienie: %2f\n', Min);

figure; plot(w,unwrap(angle(H))); xlabel('s = jw'); title('angle(H(f)) [rad]'); grid;

% zero transmitancji słuzy do usuwania wybranych czestotliwosci
% (powoduje "dołek"/"szczeline" w ch-ce amplitudowej filtra), 
% natomiast biegun transmitancji - słuzy do wzmacniania
% wybranych czestotliwosci (powoduje "górke"/"garb")