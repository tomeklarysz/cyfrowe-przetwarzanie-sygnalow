clear all; %close all;

wdb3 = 2*pi*100;
R = wdb3;                             % promien okregu

N_values = [2, 4, 6, 8];
f = 0 : 10 : 3000;                % czestotliwosc w hercach
w = 2*pi*f;                        % czestotliwosc katowa, pulsacja
s = j*w;                           % zmienna transformacji Laplace'a
figure;
for i = 1:length(N_values)
    N = N_values(i);

    alpha = pi/N;                            % kat "kawalka tortu" (okregu)
    beta  = pi/2 + alpha/2 + alpha*(0:N-1);  % katy kolejnych biegunow transmitancji
    p = R*exp(j*beta);                       % bieguny transmitancji lezace na okregu
    z = []; wzm = prod(-p); 
    b = poly(z); 
    % b = real(b);
    a = poly(p); 
    % a = real(a);
    % zplane(b,a); grid;

    H = polyval(b,s) ./ polyval(a,s);  % h(s) --> H(f) dla s=j*w: iloraz dwoch wielomianow
    H = H ./ max(H);

    subplot(2,2,1);
    plot(f,abs(H)); title('|H(f)| [dB] oś w skali liniowej'); legend('N=2','N=4','N=6','N=8'); 
    xlabel('f [Hz]'); ylabel('H [f]'); xlim([0 f(end)]); grid; hold on;
    
    subplot(2,2,2); 
    semilogx(f,20*log10(abs(H))); title('|H(f)| [dB] (oś f w skali log)'); legend('N=2','N=4','N=6','N=8');
    xlabel('f [Hz]'); ylabel('H [f]'); xlim([0 f(end)]); grid; hold on;
    
    subplot(2,2,3); 
    plot(f,angle(H)); title('angle(H(f)) [rad]'); legend('N=2','N=4','N=6','N=8');
    xlabel('f [Hz]'); ylabel('Faza [rad])'); xlim([0 f(end)]); grid; hold on;
end