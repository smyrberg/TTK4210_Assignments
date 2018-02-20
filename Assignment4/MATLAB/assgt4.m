close all
clear variables
clc

%% 1b, pole vectors
g11 = tf([3 6],[1 4 3]); g12 = tf(2,[1 1]);
g21 = tf(1, [1 2]);      g22 = tf(1, [1 3]);
G = [g11 g12 ; g21 g22];

sys_ss = ss(G);
A = sys_ss.A; B = sys_ss.B; C = sys_ss.C; D = sys_ss.D;

[T, Po] = eig(A);
yp = C*T;
[Q, Pi] = eig(A');
up = B'*Q;
shouldbezero = Po-Pi;

%% 1c, RGA
RGA = G.*inv(G).';
RGA_ss = ss(RGA);

%% simulation
%sim('assignment4.slx');

%% plot