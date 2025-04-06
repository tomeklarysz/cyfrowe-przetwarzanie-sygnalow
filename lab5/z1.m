clear all; close all;
p12 = -0.5 + j*9.5; p12 = [p12, conj(p12)];
p34 = -1 + j*10; p34 = [p34, conj(p34)];
p56 = -0.5 + j*10.5; p56 = [p56, conj(p56)];
p = [p12 p34 p56];
z = [-j*5 j*5 -j*15 j*15]; 

figure; plot(real(z),imag(z),'bo', real(p),imag(p),'r*'); grid;
title('Zera (o) i Bieguny (*)'); xlabel('Real()'); ylabel('Imag()'); pause

f = 0 : 0.1 : 1000; 
w = 2*pi*f; 
s = j*w;
a = poly(p);
b = poly(z);
H = polyval(b,s) ./ polyval(a,s);

figure; plot(s, abs(H)); xlabel('s = jw [rad/s]'); title('|H(jw)|'); grid; pause;
figure; plot(s,20*log10(abs(H))); xlabel('s = jw [rad/s]'); title('|H(jw)| [dB]'); grid; pause