clear all; close all;
load("adsl_x.mat");

pozycje = zeros(4,1);
start_prefix = 1;
koniec_prefix = 32;
korelacje = zeros(2049-32,1);
% wyniki
for i = 1:2049-544 
    prefix = x(start_prefix:koniec_prefix);
    okno = x(start_prefix+512:koniec_prefix+512);
    r = xcorr(prefix,okno);

    start_prefix = start_prefix + 1;
    koniec_prefix = koniec_prefix + 1;
end

% plot(r)