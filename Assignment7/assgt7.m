close all
clear variables
clc

%% 
sys_delay = 2;
sys_num = 2.5*[-10 1];
sys_den = [1000 110 1];
dist_num = [1.5];
dist_den = [100 1];
G = tf(sys_num,sys_den,'InputDelay', sys_delay);
Gd =  tf(dist_num, dist_den);
sys = [G Gd];

Ts = 1;
sysd = c2d(sys, Ts);

[A,B,C,D] = ssdata(sysd, Ts);

%% test
figure
step(sysd, 100);
hold on;
step([G Gd], 100);