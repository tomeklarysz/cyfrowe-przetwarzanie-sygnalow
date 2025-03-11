clear all; close all;
load("adsl_x.mat");

prefix = x(1:32);
ostatnie = x(512:544);

pozycje = zeros(3,1);
for i = 1:3
    start = (i-1) * 544 + 1;

    prefix = x(start:start + 31);
    koncowka = x(start + 512: start + 543);

    r = xcorr(prefix, koncowka);
    [m, I] = max(r);

    % pozycje(i) = 
end