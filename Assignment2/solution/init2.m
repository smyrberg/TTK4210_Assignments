%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TTK4210                                   %
% Assignment 2 - Solution                   %
%                                           %
% Author:   Morten Hovd & Anders Fougner    %
% Version:  2.0                             %
% Date:     02.01.2008                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference signals                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y1amp  = 1;
y1freq = 0.005;
y2amp  = 0;
y2freq = 0.005;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System parameters                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A     = [ -0.005131  0        0       0       0      ;
           0        -0.07366  0       0       0      ;
           0         0       -0.1829  0       0      ;
           0         0        0      -0.4620  0.9895 ;
           0         0        0      -0.9895 -0.4620 ];  
B     = [ -0.629  0.624 ;
           0.055 -0.172 ;
           0.030 -0.108 ;
          -0.186 -0.139 ;
          -1.230 -0.056 ];
C     = [ -0.7223 -0.5170  0.3386 -0.1633  0.1121 ;
          -0.8913 -0.4728  0.9876  0.8425  0.2186 ];
Bd    = [ -0.062 -0.067 ;
           0.131  0.040 ;
           0.022 -0.106 ;
          -0.188  0.027 ;
          -0.045  0.014 ];
D     = [ 0 0 ;
          0 0 ];
sys   = ss(A,B,C,D);
G     = tf(sys);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% White noise disturbances                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kw   = 0.01;
Wvar = kw*ones(2,1);
QXU  = eye(7);
kv   = 0.02;
Vvar = kv*ones(2,1);
QWV  = eye(7);
% Steady-state effect of disturbances:
% Gd0 = [  7.88  8.81 ;
%         11.72 11.19 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PI controller                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s   = tf('s');
Kp1 = 0.5; Kp2 = -0.5; % Signs are decided through
                       % dcgain(A,B,C,D), which results in
                       % [88.3573 -86.8074; 108.0808 -107.9375]
Ti1 = 2; Ti2 = 2;
k1  = Kp1*(Ti1*s+1)/(Ti1*s); [k1num,k1den] = tfdata(k1); k1num = k1num{1,:}; k1den = k1den{1,:};
k2  = Kp2*(Ti2*s+1)/(Ti2*s); [k2num,k2den] = tfdata(k2); k2num = k2num{1,:}; k2den = k2den{1,:};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dynamic decoupling controller             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gdiag = [G(1,1) 0      ;
         0      G(2,2) ];
% We need a non-singular D-matrix to calculate inv(G).
% Find an approximate G using a new D-matrix that does not
% introduce poles in the right-half plane
dd    = [ 1e-3   0   ;
           0   -1e-3 ];
Gapp  = ss(A,B,C,dd);
%tzero(Gapp)    % Check for zeros..
W     = inv(Gapp)*Gdiag;
W     = minreal(W);
[Wa,Wb,Wc,Wd] = ssdata(W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverted decoupling controller             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note that all elements share the same denominator
[g11num,g11den] = tfdata(sys(1,1)); 
g11den = g11den{1,:}; g11num = g11num{1,:};
[g12num,g12den] = tfdata(sys(1,2)); 
g12den = g12den{1,:}; g12num = g12num{1,:};
[g21num,g21den] = tfdata(sys(2,1)); 
g21den = g21den{1,:}; g21num = g21num{1,:};
[g22num,g22den] = tfdata(sys(2,2)); 
g22den = g22den{1,:}; g22num = g22num{1,:}; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LQG controller with integral action    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Augment plant with 2 integrators
    p      = size(C,1);
    [n,m]  = size(B);   % n=5, m=2
    Znn    = zeros(n,n); Znm    = zeros(n,m);
    Zmn    = zeros(m,n); Zmm    = zeros(m,m);
    Aint   = [A Znm; -C Zmm]; % Augment plant with integrators
    Bint   = [B; -D];         % Augment plant with integrators
    
%     Cint   = [C eye(2)]; % The output is the measurement +
                         % the integral of the error.
                         % This is OK for the controller, since
                         % it is designed from state feedback.
%     sysint = ss(Aint,Bint,Cint,D);  
%     Gint   = tf(sysint);
%     qi     = 1;
%     Qint   = qi*eye(2); % weigth on integrated error

%     sys2   = sysint;    % use augmented system
%   states = 7;         % new number of states
    states = 5;         % use old system
                        % -> old number of states

% Kalman filter (only for true states -
%                not needed for integrators)
qm          = 1;
Q           = [qm*eye(2)];
R           = eye(2);
sys_d       = ss(A,[B Bd],C,[D D]); % D is zero anyway
[kestold,KFL,P,M,Z] = kalman(sys_d,Q,R);
kest        = kestold(3:2+states,:);
Gkest       = tf(kest);

% LQR control
states      = 7;
Q           = eye(states);
R           = eye(2);
N           = 0;
[lqrK,S,e]  = lqr(Aint,Bint,Q,R);   % Shows that we only need
                                    % the A and B matrices
                                    % for LQR control


%% simulation
sim('assignment2.mdl')