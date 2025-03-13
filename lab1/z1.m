% A
clear all; close all;
A = 230; % V
f = 50;  % Hz
T = 0.1;

fs1 = 10e3;
dt1 = 1/fs1;
t1 = 0:dt1:T;

fs2 = 500;
dt2 = 1/fs2;
t2 = 0:dt2:T;

fs3 = 200;
dt3 = 1/fs3;
t3 = 0:dt3:T;

x1 = A*sin(2*pi*f.*t1);
x2 = A*sin(2*pi*f.*t2);
x3 = A*sin(2*pi*f.*t3);
plot(t1,x1,'b-',t2,x2,'r-o',t3,x3,'k-x'); grid;
title('f = 50 Hz');
legend('fs = 10 kHz','fs = 500 Hz','fs = 200 Hz'); pause;

% B
T = 1;
fs1 = 10e3;
fs2 = 51;  %fs2 = 26;
fs3 = 50;  %fs3 = 25;
fs4 = 49;  %fs4 = 24;

t1 = 0:1/fs1:T;
t2 = 0:1/fs2:T;
t3 = 0:1/fs3:T;
t4 = 0:1/fs4:T;

x1 = A*sin(2*pi*f.*t1);
x2 = A*sin(2*pi*f.*t2);
x3 = A*sin(2*pi*f.*t3);
x4 = A*sin(2*pi*f.*t4);
plot(t1,x1,'b-',t2,x2,'g-o',t3,x3,'r-o',t4,x4,'k-o'); grid; 
title('f = 50 Hz');
legend('fs = 10 kHz','fs = 51 Hz','fs = 50 Hz','fs = 49 Hz'); pause;

% C
fs = 100;
T = 1;
t = 0:1/fs:T;
obieg = 1;
for f = 0:5:300
    x = A*sin(2*pi*f*t);
    plot(t,x,'b-'); 
    title([num2str(obieg), '. obieg, f = ', num2str(f), 'Hz']); pause;
    obieg = obieg + 1;
end

x1 = A*sin(2*pi*5*t);
x2 = A*sin(2*pi*105*t);
x3 = A*sin(2*pi*205*t);
plot(t,x1,'b-'); hold on;
plot(t,x2,'r-o'); hold on;
plot(t,x3,'k-x'); hold off; 
title('sinus'); 
legend('fs = 5 Hz','fs = 105 Hz','fs = 205 Hz'); pause;

% f = k*fs +- fx
% te sinusoidy po spróbkowaniu są nierozróżnialne, zeby tak nie bylo
% max czestotliwosc = polowa czestotliwosci probkowania

x1 = A*sin(2*pi*95*t);
x2 = A*sin(2*pi*195*t);
x3 = A*sin(2*pi*295*t);
plot(t,x1,'b-o'); hold on;
plot(t,x2,'ro'); hold on;
plot(t,x3,'kx'); hold off; 
title('sinus');
legend('fs = 95 Hz','fs = 195 Hz','fs = 295 Hz'); pause;

x1 = A*sin(2*pi*95*t);
x2 = A*sin(2*pi*105*t);
plot(t,x1,'b-o'); hold on;
plot(t,x2,'r-o'); hold off;
title('sinus');
legend('fs = 95 Hz','fs = 105 Hz'); pause;

% dla f = k*fs - fx
% identyczne, tylko ze znakiem minus

% cosinus:

x1 = A*cos(2*pi*5*t);
x2 = A*cos(2*pi*105*t);
x3 = A*cos(2*pi*205*t);
plot(t,x1,'b-'); hold on;
plot(t,x2,'r-o'); hold on;
plot(t,x3,'k-x'); hold off;
title('cosinus');
legend('fs = 5 Hz','fs = 105 Hz','fs = 205 Hz'); pause;

x1 = A*cos(2*pi*95*t);
x2 = A*cos(2*pi*105*t);
plot(t,x1,'b-o'); hold on;
plot(t,x2,'ro'); hold off;
title('cosinus');
legend('fs = 95 Hz','fs = 105 Hz'); pause;

% dla f = k*fs - fx identyczne

xlabel('czas [s]');