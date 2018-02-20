close all
clear variables
clc

%% Variables
p_ref = 0; f_ref = 0;
Kp_p = 18; Kp_f = 3.04;
Ti_p = 3.45; Ti_f = 4.63;
Ki_p = 1/Ti_p; Ki_f = 1/Ti_f;

sim('assignment3.slx');
%% Plot
figure
subplot(211)
hold on;
plot(f); plot(p); plot(d); legend('flow rate', 'pressure','disturbance'); 

subplot(212)
hold on; 
plot(u_f); plot(u_p); legend('Controller output from flow control', 'Controller output from pressure control');