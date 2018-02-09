close all
clear variables
clc

%% State space
A =  [ -0.005131 0 0 0 0 ;
        0 -0.07366 0 0 0 ;
        0 0 -0.1829 0 0 ;
        0 0 0 -0.4620 0.9895 ;
        0 0 0 -0.9895 -0.4620 ];
B =  [ -0.629 0.624 ;
        0.055 -0.172 ;
        0.030 -0.108 ;
        -0.186 -0.139 ;
        -1.230 -0.056 ];
C =  [ -0.7223 -0.5170 0.3386 -0.1633 0.1121 ;
        -0.8913 -0.4728 0.9876 0.8425 0.2186 ];
Bd =  [ -0.062 -0.067 ;
        0.131 0.040 ;
        0.022 -0.106 ;
        -0.188 0.027 ;
        -0.045 0.014 ];
    
%% PI controller

Kp = [3 0;
      0 -0.05];
Ti1 = 25;
Ti2 = 10;
Ki = [1/Ti1 0;
      0 1/Ti2];

sim('assignment2_PI.slx');

%% Decoupling
sys = ss(A,B,C,0);
G = tf(sys);
Gdes = blkdiag(G(1,1) , G(2,2));
W = G\Gdes;
decoup = ss(W);

Kp = [0.2 0;
      0 -0.1];
Ti1 = 0.5;
Ti2 = 10;
Ki = [1/Ti1 0;
      0 1/Ti2];

sim('assignment2_Decoupling.slx');

%% Kalman filter
[K,S,e] = lqr(A,B,eye(5), eye(2));
Kp = [0.2 0;
      0 -0.1];
Ti1 = 1;
Ti2 = 10;
Ki = [1/Ti1 0;
      0 1/Ti2];
sim('assignment2_Kalman.slx');
plot(xhat);
  
%% Plot
figure
hold on;
plot(y);plot(ref); legend('first', 'second','ref1','ref2')

    
