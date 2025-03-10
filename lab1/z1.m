% A
clear all; close all;
A = 230; % V
f = 50;  % Hx
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
% plot(t1,x1,'b-',t2,x2,'r-o',t3,x3,'k-x');

% B
T = 1;
fs1 = 10e3;
fs2 = 26;
fs3 = 25;
fs4 = 24;

t1 = 0:1/fs1:T;
t2 = 0:1/fs2:T;
t3 = 0:1/fs3:T;
t4 = 0:1/fs4:T;

x1 = A*sin(2*pi*f.*t1);
x2 = A*sin(2*pi*f.*t2);
x3 = A*sin(2*pi*f.*t3);
x4 = A*sin(2*pi*f.*t4);

% plot(t1,x1,'b-',t2,x2,'g-o',t3,x3,'r-o',t4,x4,'k-o');

fs = 100;
T = 1;
t = 0:1/fs:T;
for f = 0:5:300
    x = A*sin(2*pi*f*t);
    plot(t,x,'b-'); pause;
end