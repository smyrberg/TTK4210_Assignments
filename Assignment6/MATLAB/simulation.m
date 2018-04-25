close all
clear variables 
clc

%% Get logging file
Import_Logging_lst

%% normalize data
cut = 1500;
endcut = 14000;

controller = TC1015;
controller_cut = controller(cut:endcut,:);
y = controller_cut(:,1) - controller_cut(1,1);
y_ref =  controller_cut(:,2) - controller_cut(1,2);
u = controller_cut(:,3) - controller_cut(1,3);
Time_cut = Time(cut:endcut) - Time(cut);

%% system identification
Ts = 1;
data = iddata(y,u,Ts);
nx = 2;
delay = 60;
sys = n4sid(data,nx, 'inputdelay',delay);

%% simulate
simtime = 14400;
steptime= 600;
Ti = 1440;
Kp = -150; %
Ki = 1/Ti;
%y_sim = lsim(sys,u);
sim('systemsim');

y_out_OL.Time = y_out_OL.Time./60;
u_out_OL.Time = u_out_OL.Time./60;
ref_out_CL.Time = ref_out_CL.Time./60;
y_out_CL.Time = y_out_CL.Time./60;
u_out_CL.Time = u_out_CL.Time./60;

%% plot
figure(1)
plot(y_out_CL); hold on;
plot(ref_out_CL);
%plot(u_out_CL);
xlabel('Time (minutes)'); 
title(['Closed loop response with Kp = ' num2str(Kp) ' and Ti = ' num2str(Ti) ]);

figure(2)
plot(y_out_OL); hold on;
plot(u_out_OL);
xlabel('Time (minutes)'); 
title(['Open loop response when applying step to input']);


