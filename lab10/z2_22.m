clear all; close all;

[x,fpr] = audioread('mowa1.wav');  
% soundsc(x(1:floor(end/4)), fpr); pause;

N = length(x);       
Mlen = 240;          
Mstep = 180;        
Np = 10;             
gdzie = 181;       

s = [];              
bs = zeros(1, Np);  

nr = 25;            
n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
bx = x(n);

bx = bx - mean(bx);  

for k = 0 : Mlen-1
    r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) );
end

offset = 20; 
rmax = max(r(offset : Mlen));
imax = find(r == rmax);

if (rmax > 0.35*r(1))
    T = imax;      
else
    T = 0;         
end

if (T > 80) 
    T = round(T/2); 
end

rr = (r(2:Np+1))';

% Budujemy macierz autokorelacji
for m = 1:Np
    R(m,1:Np) = [r(m:-1:2) r(1:Np-(m-1))];
end

a = -inv(R)*rr;

wzm = r(1) + r(2:Np+1)*a;

H = freqz(1, [1; a]);

sygnal_resztkowy = filter([1; a], 1, x(n));

liczbaokresow = 5;
sygnal_resztkowy_avg = mean(reshape(sygnal_resztkowy(1:T*liczbaokresow), T, liczbaokresow), 2)';

if (T ~= 0)
    gdzie = gdzie - Mstep; 
end

for n = 1 : Mstep
    if (T == 0)
        pob = 2*(rand(1,1) - 0.5); 
        gdzie = 271;
    else
        pob = sygnal_resztkowy_avg(mod(gdzie-1, T) + 1); 
        gdzie = gdzie + 1;
    end
    ss(n) = wzm * pob - bs * a;
    bs = [ss(n) bs(1:Np-1)];
end

s = [s ss]; 

plot(s);
title('Mowa zsyntezowana');
pause;
soundsc(s(1:floor(end/4)), fpr);